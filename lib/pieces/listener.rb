module Pieces
  class Listener
    attr_reader :path
    attr_reader :build_method
    attr_reader :force_polling

    def initialize(config = {})
      @path = config[:path] || Dir.pwd
      @build_method = config[:build_method] || :build
      @force_polling = config[:force_polling] || false
      build_pieces
    end

    def listen
      Listen.to("#{path}/config/", "#{path}/app/", force_polling: force_polling) do
        print "Rebuilding #{path}... "
        build_pieces
        puts 'done.'
      end.tap(&:start)
    end

    private

    def build_pieces
      Pieces::Builder.new(path: path).send(build_method)
    end
  end
end
