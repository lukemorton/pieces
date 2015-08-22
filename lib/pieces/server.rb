require 'rack'
require 'listen'
require 'sprockets'
require 'pieces/listener'

module Pieces
  class Server < Rack::Server
    attr_reader :config

    def initialize(config = {})
      @config = config
      super({})
    end

    def start
      Pieces::Listener.new(path: config.path).listen
      super
    end

    def sprockets_env
      Sprockets::Environment.new(config.path).tap do |env|
        env.append_path 'app/assets/javascripts'
        env.append_path 'app/assets/stylesheets'
        env.append_path 'app/views'
      end
    end

    def app
      urls = files_to_serve(config.path)
      build_path = "#{config.path}/build"
      assets_app = sprockets_env

      Rack::Builder.app do
        use Rack::Reloader
        use Rack::Static, urls: urls, root: build_path, index: 'index.html'
        map('/assets') { run assets_app } unless defined? ::Rails
        run Proc.new { |env| [404, {}, ['Not found']] }
      end
    end

    private

    def files_to_serve(path)
      Dir["#{config.path}/build/**/*"].map { |file| file.sub("#{config.path}/build", '') }
    end
  end
end
