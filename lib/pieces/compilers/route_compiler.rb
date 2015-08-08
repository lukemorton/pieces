module Pieces
  class RouteCompiler
    attr_reader :path
    attr_reader :globals

    def initialize(config)
      @path = config[:path] || Dir.pwd
      @globals = config[:globals] || {}
    end

    def compile(files, name, route)
      files["#{name}.html"] = { contents: '', type: 'html' }

      pieces(route).each do |piece, data|
        files["#{name}.html"][:contents] << compile_piece(piece, data)
      end

      files
    end

    private

    def piece_path(piece)
      Dir["#{path}/pieces/{#{piece},#{piece}/#{piece},application/#{piece}}.html.*"].first
    end

    def route_globals(route)
      globals.merge(route['_global'] || {})
    end

    def merge_globals(data, route)
      data['_global'] = route_globals(route).merge(data['_global'] || {})
      data
    end

    def pieces(data)
      data['_pieces'].map do |piece|
        [piece.keys.first, merge_globals(piece.values.first, data)]
      end
    end

    def compile_piece(piece, data)
      view_model = OpenStruct.new(data['_global'].merge(data))
      Tilt.new(piece_path(piece)).render(view_model) { yield_route_pieces(data) }
    end

    def yield_route_pieces(parent_data)
      return '' unless parent_data.has_key?('_pieces')

      pieces(parent_data).reduce('') do |contents, (piece, data)|
        contents << compile_piece(piece, data)
      end
    end
  end
end
