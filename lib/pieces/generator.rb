require 'thor'

module Pieces
  class Generator
    def self.init(config = {})
      new(Pieces::Config.new(config.merge(load: false))).init
    end

    def self.from_superclass(method, default)
      default
    end

    include Thor::Actions
    include Thor::Shell
    include Configurable

    source_root File.expand_path('../../../examples/boilerplate', __FILE__)

    attr_reader :options

    def initialize(config)
      super
      @options = {}
      self.destination_root = config.path
    end

    def init
      directory 'app/assets/stylesheets'
      directory 'app/views'
      copy_file 'config/pieces.yml'
      copy_file 'Gemfile'
    end
  end
end
