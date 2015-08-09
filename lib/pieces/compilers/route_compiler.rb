require 'ostruct'

module Pieces
  class RouteCompiler
    attr_reader :path
    attr_reader :globals

    def initialize(config)
      @path = config[:path] || Dir.pwd
      @globals = config[:globals] || {}
    end

    def compile(files, name, route)
      files.merge("#{name}.html" => { contents: yield_pieces(route), type: 'html' })
    end

    private

    def piece_path(piece)
      Dir["#{path}/app/views/{#{piece},#{piece}/#{piece},application/#{piece}}.html.*"].first
    end

    def route_globals(route)
      globals.merge(route['_global'] || {})
    end

    def merge_globals(data, route)
      data.merge('_global' => route_globals(route).merge(data['_global'] || {}))
    end

    def pieces(data)
      (data['_pieces'] || []).map do |piece|
        [piece.keys.first, merge_globals(piece.values.first, data)]
      end
    end

    def compile_piece(piece, data)
      view_model = ViewModel.new(data['_global'].merge(data))
      ::Tilt.new(piece_path(piece)).render(view_model) { yield_pieces(data) }
    end

    def yield_pieces(data)
      pieces(data).reduce('') do |contents, (piece, data)|
        contents << compile_piece(piece, data)
      end
    end

    class ViewModel < OpenStruct
      if defined?(ActionView)
        include ActionView::Context
        include ActionView::Helpers
      end

      def initialize(*)
        super
        _prepare_context if defined?(ActionView)
      end
    end
  end
end
