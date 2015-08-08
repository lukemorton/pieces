require 'rack'
require 'listen'

module Pieces
  class Server < Rack::Server
    def self.start(config = {})
      Pieces::Builder.build(path: config[:path])

      server = new(config.merge(app: app(config[:path])))

      listener = Listen.to("#{config[:path]}/config") do
        print "Rebuilding #{config[:path]}... "
        Pieces::Builder.build(path: config[:path])
        puts 'done.'
      end

      listener.start
      server.start
    end

    private

    def self.app(path)
      files = files_to_serve(path)

      Rack::Builder.new do
        use Rack::Static, urls: files,
                          root: "#{path}/build",
                          index: 'index.html'

        use Rack::Reloader

        run Proc.new { |env| [404, {}, ['Not found']] }
      end.to_app
    end

    def self.files_to_serve(path)
      Dir["#{path}/build/**/*"].map { |file| file.sub("#{path}/build", '') }
    end
  end
end
