require 'pieces/rails/railtie'
require 'pieces/server'

module Pieces
  class Rails
    def self.mount(config = {})
      mounted_at = config.delete(:at)

      config = Config.new(config.merge(path: config[:path] || ::Rails.root,
                                       '_force_polling' => config[:force_polling],
                                       '_mounted_at' => mounted_at))

      { new(config).mount => mounted_at }
    end

    include Configurable

    def mount
      Listener.new(config).listen
      Server.new(config).app
    end
  end
end
