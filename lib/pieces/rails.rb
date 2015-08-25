require 'pieces/rails/railtie'

module Pieces
  class Rails
    def self.mount(config = {})
      mounted_at = config.delete(:at)

      config = Config.new(config.merge(path: config[:path] || ::Rails.root,
                                       '_mounted_at' => mounted_at))

      { new(config).mount => mounted_at }
    end

    include Configurable

    def mount
      Server.new(config).app
    end
  end
end
