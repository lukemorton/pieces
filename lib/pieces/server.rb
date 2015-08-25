require 'rack'
require 'listen'
require 'sprockets'
require 'pieces/listener'

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

    def start
      Pieces::Listener.new(config).listen
      super
    end

    def sprockets_env
      Sprockets::Environment.new(config.path).tap do |env|
        env.append_path 'app/assets/javascripts'
        env.append_path 'app/assets/stylesheets'
        env.append_path 'app/assets'
        env.append_path 'app/views'
        env.js_compressor = :uglify if defined? ::Uglifier
        env.css_compressor = :scss if defined? ::Sass
      end
    end

    def app
      urls = files_to_serve(config.path)
      build_path = "#{config.path}/build"
      assets_app = sprockets_env

      Rack::Builder.app do
        use Rack::Reloader
        map('/assets') { run assets_app } unless defined? ::Rails
        use Rack::Static, urls: [''], root: build_path, index: 'index.html'
        run Proc.new { |env| [404, {}, ['Not found']] }
      end
    end

    private

    def files_to_serve(path)
      Dir["#{config.path}/build/**/*"].map { |file| file.sub("#{config.path}/build", '') }
    end
  end
end
