require 'rack'
require 'listen'

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

    def app
      files = files_to_serve(path)
      build_path = "#{path}/build"

      Rack::Builder.app do
        use Rack::Reloader

        use Rack::Static, urls: files,
                          root: build_path,
                          index: 'index.html'

        run Proc.new { |env| [404, {}, ['Not found']] }
      end
    end

    private

    def files_to_serve(path)
      Dir["#{path}/build/**/*"].map { |file| file.sub("#{path}/build", '') }
    end
  end
end
