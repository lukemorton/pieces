module Pieces
  class RouteCompiler
    attr_reader :path
    attr_reader :globals

    def initialize(config)
      @path = config[:path] || Dir.pwd
      @globals = config[:globals] || {}
    end

    def compile(files, name, route)
      route['_pieces'].reduce(files) do |files, piece|
        piece, data = piece.keys.first, piece.values.first
        data['_global'] = globals.merge(route.delete('_global') || {}).merge(data['_global'] || {})

        files["#{name}.html"] = { contents: '', type: 'html' } unless files.has_key?("#{name}.html")
        view_model = OpenStruct.new(data['_global'].merge(data))
        content = Tilt.new(piece_path(piece)).render(view_model) { yield_route_pieces(data) }
        files["#{name}.html"][:contents] << content

        files
      end
    end

    private

    def piece_path(piece)
      Dir["#{path}/pieces/{#{piece},#{piece}/#{piece},application/#{piece}}.html.*"].first
    end

    def yield_route_pieces(parent_data)
      return '' unless parent_data.has_key?('_pieces')

      parent_data['_pieces'].reduce('') do |content, piece|
        piece, data = piece.keys.first, piece.values.first
        data['_global'] = (parent_data['_global'] || {}).merge(data['_global'] || {})
        view_model = OpenStruct.new(data['_global'].merge(data))
        content << Tilt.new(piece_path(piece)).render(view_model) { yield_route_pieces(data) }
      end
    end
  end
end
