require 'pieces'
require 'thor'

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
  end
end
