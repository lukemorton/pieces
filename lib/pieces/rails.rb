module Pieces
  class Rails
    def mount(options = {})
      path = options[:path] || Dir.pwd
      Pieces::Listener.new(path: path, build_method: :build_routes).listen
      Pieces::Server.new(options.merge(path: path)).app
    end
  end
end
