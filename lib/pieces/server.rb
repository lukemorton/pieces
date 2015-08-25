require 'rack'
require 'sprockets'

module Pieces
  class Server < Rack::Server
    def self.start(config = {})
      new(Config.new(config)).start
    end

    attr_reader :config

    def initialize(config)
      @config = config
      super({})
    end

    def sprockets_env
      Sprockets::Environment.new(config.path).tap do |env|
        env.append_path 'app/assets/javascripts'
        env.append_path 'app/assets/stylesheets'
        env.append_path 'vendor/assets/stylesheets'
        env.append_path 'vendor/assets/javascripts'
        env.append_path 'app/assets'
        env.append_path 'app/views'
        env.append_path 'app/views'

        if defined? ::Sass
          ::Sass.load_paths.each { |path| env.append_path(path) }
          env.css_compressor = :scss
        end

        if defined? ::Uglifier
          env.js_compressor = :uglify
        end
      end
    end

    def app
      urls = files_to_serve(config.path)
      build_path = "#{config.path}/build"
      assets_app = sprockets_env
      config.env = sprockets_env
      app = App.new(config)

      Rack::Builder.app do
        use Rack::Reloader
        map('/assets') { run assets_app } unless defined? ::Rails
        run app
      end
    end

    private

    def files_to_serve(path)
      Dir["#{config.path}/build/**/*"].map { |file| file.sub("#{config.path}/build", '') }
    end
  end
end
