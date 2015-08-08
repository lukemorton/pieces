module Pieces
  class Rails
    attr_reader :path

    def mount(options = {})
      @path = options[:path] || Dir.pwd
      build_pieces
      listener.start
      Pieces::Server.new(options.merge(path: @path)).app
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
  end
end
