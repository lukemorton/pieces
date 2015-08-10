module Pieces
  class Listener
    attr_reader :path
    attr_reader :build_method

    def initialize(config = {})
      @path = config[:path] || Dir.pwd
      @build_method = config[:build_method] || :build
      build_pieces
    end

    def listen
      Listen.to("#{path}/config/", "#{path}/app/") do
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
