module Pieces
  class App
    include Configurable

    def call(env)
      config.reload!
      request = Rack::Request.new(env)

      if route = match_route(request)
        render_page(route)
      else
        render_page_not_found
      end
    end

    private

    def route_from_path(request)
      start_index = config.mounted_at.nil? ? 1 : (config.mounted_at.length + 1)
      path = request.path[start_index..-1]

      if path == ''
        'index'
      else
        path.gsub(/\.html$/, '')
      end
    end

    def match_route(request)
      route = route_from_path(request)

      if request.get? and config.routes.keys.include?(route)
        route
      end
    end

    def route_compiler
      @route_compiler ||= RouteCompiler.new(config)
    end

    def render_page(route)
      files = route_compiler.compile({}, route, config.routes[route])
      ['200', {'Content-Type' => 'text/html'}, files.values.map { |f| f[:contents] }]
    end

    def render_page_not_found
      [404, {}, ['Not found']]
    end
  end
end
