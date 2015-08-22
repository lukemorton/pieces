require 'pieces/rails/railtie'
require 'pieces/server'

module Pieces
  class Rails
    attr_reader :path, :force_polling

    def initialize(config = {})
      @path = path || ::Rails.root
      @force_polling = config[:force_polling]
    end

    def mount
      Listener.new(path: path, force_polling: force_polling).listen
      Server.new(Config.new(path: path)).app
    end
  end
end
