require 'pieces/backtrace_formatter'

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
      Listen.to("#{path}/config/", "#{path}/app/views", force_polling: force_polling) do
        rebuild_pieces
      end.tap(&:start)
    end

    private

    def build_pieces
      Pieces::Builder.new(path: path).send(build_method)
    rescue => e
      puts Pieces::BacktraceFormatter.format(e)
      exit(1)
    end

    def rebuild_pieces
      print "\nRebuilding #{File.basename(path)}... "
      Pieces::Builder.new(path: path).send(build_method)
      puts 'done.'
    rescue => e
      puts 'an error occurred.'
      puts ''
      puts Pieces::BacktraceFormatter.format(e)
    end
  end
end
