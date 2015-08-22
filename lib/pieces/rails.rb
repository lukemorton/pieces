require 'pieces/rails/railtie'
require 'pieces/server'

module Pieces
  class Rails
    def self.mount(config = {})
      config = Config.new(config.merge(path: config[:path] || ::Rails.root,
                                       'force_polling' => config[:force_polling]))
      new(config).mount
    end

    include Configurable

    def mount
      Listener.new(config).listen
      Server.new(config).app
    end
  end
end
