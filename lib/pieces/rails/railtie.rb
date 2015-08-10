module Pieces
  class Rails
    class Railtie < ::Rails::Railtie
      generators do
        require 'pieces/rails/install_generator'
      end
    end
  end
end
