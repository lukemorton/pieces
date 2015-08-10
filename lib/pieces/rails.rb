require 'pieces/rails/railtie'

module Pieces
  class Rails
    attr_reader :path, :force_polling

    def initialize(options = {})
      @path = path || Dir.pwd
      @force_polling = options[:force_polling]
    end

    def mount
      Pieces::Listener.new(path: path, build_method: :build_routes, force_polling: force_polling).listen
      Pieces::Server.new(path: path).app
    end
  end
end
