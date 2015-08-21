require 'ostruct'

module Pieces
  class RouteCompiler
    attr_reader :path
    attr_reader :env
    attr_reader :globals
    attr_reader :asset_prefix

    def initialize(config)
      @path = config[:path] || Dir.pwd
      @env = config[:env]
      @globals = config[:globals] || {}
      @asset_prefix = config[:asset_prefix]
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
      view_model.env = env
      view_model.asset_prefix = asset_prefix
      ::Tilt.new(piece_path(piece)).render(view_model) { yield_pieces(data) }
    end

    def yield_pieces(data)
      pieces(data).reduce('') do |contents, (piece, data)|
        contents << compile_piece(piece, data)
      end
    end

    class ViewModel < OpenStruct
      attr_accessor :env
      attr_accessor :asset_prefix

      begin
        require 'action_view'
        include ActionView::Context
        include ActionView::Helpers
      rescue LoadError => e
      end

      def initialize(*)
        super
        _prepare_context if respond_to?(:_prepare_context)
      end

      def compute_asset_path(path, options = {})
        if env.resolve!(path)
          File.join(asset_prefix || '/assets', path)
        else
          super
        end
      end
    end
  end
end
