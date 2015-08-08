require 'rack'
require 'listen'

module Pieces
  class Server < Rack::Server
    attr_reader :path

    def initialize(options = {})
      @path = options[:path] or Dir.pwd
      super
    end

    def start
      build_pieces
      listener.start
      super
    end

    def app
      files = files_to_serve(path)
      build_path = "#{path}/build"

      Rack::Builder.app do
        # use Rack::Reloader

        use Rack::Static, urls: files,
                          root: build_path,
                          index: 'index.html'

        run Proc.new { |env| [404, {}, ['Not found']] }
      end
    end

    private

    def build_pieces
      Pieces::Builder.build(path: path)
    end

    def listener
      Listen.to("#{path}/config/", "#{path}/app/views/") do
        print "Rebuilding #{path}... "
        build_pieces
        puts 'done.'
      end
    end

    def files_to_serve(path)
      Dir["#{path}/build/**/*"].map { |file| file.sub("#{path}/build", '') }
    end
  end
end
