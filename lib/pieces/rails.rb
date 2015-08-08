module Pieces
  class Rails
    def mount(options = {})
      path = options[:path] || Dir.pwd
      Pieces::Listener.new(path: path).listen
      Pieces::Server.new(options.merge(path: path)).app
    end
  end
end
