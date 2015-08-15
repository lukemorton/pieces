require 'rack'
require 'listen'
require 'sprockets'

module Pieces
  class Server < Rack::Server
    attr_reader :path

    def initialize(options = {})
      @path = options[:path] || Dir.pwd
      super
    end

    def start
      Pieces::Listener.new(path: path).listen
      super
    end

    def sprockets_env
      Sprockets::Environment.new.tap do |env|
        env.append_path 'app/assets/javascripts'
        env.append_path 'app/assets/stylesheets'
      end
    end

    def app
      files = files_to_serve(path)
      build_path = "#{path}/build"

      Rack::Builder.app do
        use Rack::Reloader
        use Rack::Static, urls: files, root: build_path, index: 'index.html'
        map('/assets') { run sprockets_env } unless defined? ::Rails
        run Proc.new { |env| [404, {}, ['Not found']] }
      end
    end

    private

    def files_to_serve(path)
      Dir["#{path}/build/**/*"].map { |file| file.sub("#{path}/build", '') }
    end
  end
end
