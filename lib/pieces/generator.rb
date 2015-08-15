require 'thor'

module Pieces
  class Generator
    def self.init(config = {})
      new(config).init
    end

    def self.from_superclass(method, default)
      default
    end

    include Thor::Actions
    include Thor::Shell

    source_root File.expand_path('../../../examples/boilerplate', __FILE__)

    attr_reader :path, :options

    def initialize(config = {})
      @path = config[:path] || Dir.pwd
      @options = {}
      self.destination_root = config[:path]
    end

    def init
      directory 'app/views'
      copy_file 'config/pieces.yml'
      copy_file 'Gemfile'
    end
  end
end
