module Pieces
  class Listener
    attr_reader :path

    def initialize(config = {})
      @path = config[:path] || Dir.pwd
      build_pieces
    end

    def listen
      Listen.to("#{path}/config/", "#{path}/app/views/") do
        print "Rebuilding #{path}... "
        build_pieces
        puts 'done.'
      end.tap(&:start)
    end

    private

    def build_pieces
      Pieces::Builder.build(path: path)
    end
  end
end
