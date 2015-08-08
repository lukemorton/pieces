require 'rack'

module Pieces
  class Server < Rack::Server
    def self.start(config = {})
      files = files_to_serve(config[:path])

      app = Rack::Builder.new do
        use Rack::Static, urls: files,
                          root: "#{config[:path]}/build",
                          index: 'index.html'

        run Proc.new { |env| [404, {}, ['Not found']] }
      end

      super(config.merge(app: app))
    end

    private

    def self.files_to_serve(path)
      Dir["#{path}/build/**/*"].map { |file| file.sub("#{path}/build", '') }
    end
  end
end
