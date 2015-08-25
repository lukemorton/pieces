require 'thor'
require 'pieces'

module Pieces
  class CLI < Thor
    desc 'init DIR', 'create new pieces app in DIR'
    def init(path = '.')
      print "Placing new pieces in #{path}... "
      Pieces::Generator.init(path: path)
      puts 'done.'
    end

    desc 'build DIR', 'build pieces in DIR'
    def build(path = '.')
      print "Building pieces into #{path}... "
      Pieces::Builder.build(path: path)
      puts 'done.'
    end

    map %w(s) => :server

    desc 'server DIR', 'serve application in DIR'
    def server(path = Dir.pwd)
      puts "Serving pieces from #{path}... "
      Pieces::Server.start(path: path)
    end

    map %w(--version -v) => :version

    desc '--version', 'get pieces version'
    def version
      puts "pieces v#{Pieces::VERSION}"
    end
  end
end
