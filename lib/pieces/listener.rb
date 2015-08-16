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
      output_backtrace(e)
      exit(1)
    end

    def rebuild_pieces
      print "\nRebuilding #{File.basename(path)}... "
      Pieces::Builder.new(path: path).send(build_method)
      puts 'done.'
    rescue => e
      puts 'an error occurred.'
      puts ''
      output_backtrace(e)
    end

    def output_backtrace(exception)
      puts "Exception<#{exception.class.name}>: #{exception.message}"
      puts ''

      begin
        require 'rails'
        trace = ::Rails.backtrace_cleaner.clean(exception.backtrace)
      rescue LoadError => e
        trace = exception.backtrace
          .delete_if { |line| !line.include?(path) }
          .map { |line| line.sub("#{path}/", '') }
      end

      puts trace.map { |line| "     #{line}" }
    end
  end
end
