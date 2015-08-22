require 'pieces/backtrace_formatter'

module Pieces
  class Listener
    def self.listen(config = {})
      new(Config.new(config)).listen
    end

    include Configurable

    def initialize(config = {})
      super
      build_pieces
    end

    def listen
      Listen.to(*paths, force_polling: config.force_polling?) do
        rebuild_pieces
      end.tap(&:start)
    end

    private

    def paths
      ["#{config.path}/config", "#{config.path}/app/views"]
    end

    def build_pieces
      Pieces::Builder.new(path: config.path).build
    rescue => e
      puts Pieces::BacktraceFormatter.format(e)
      exit(1)
    end

    def rebuild_pieces
      print "\nRebuilding #{File.basename(config.path)}... "
      Pieces::Builder.new(path: config.path).build
      puts 'done.'
    rescue => e
      puts 'an error occurred.'
      puts ''
      puts Pieces::BacktraceFormatter.format(e)
    end
  end
end
