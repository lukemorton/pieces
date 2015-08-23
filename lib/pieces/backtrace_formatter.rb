module Pieces
  class BacktraceFormatter
    include Configurable

    def format(exception)
      output = ["Exception<#{exception.class.name}>: #{exception.message}"]
      output << ''

      begin
        require 'rails'
        trace = ::Rails.backtrace_cleaner.clean(exception.backtrace)
      rescue LoadError => e
        trace = exception.backtrace
          # .delete_if { |line| !line.include?(config.path) }
          # .map { |line| line.sub("#{config.path}/", '') }
      end

      output.concat(trace.map { |line| "     #{line}" }).join("\n")
    end
  end
end
