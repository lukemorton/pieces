module Pieces
  class ConfigNotFound < RuntimeError; end

  class Config < Hash
    attr_reader :path

    def initialize(config = {})
      @path = config[:path]
      load_config!
    end

    def routes
      reject { |key, _| key =~ /^_/ }
    end

    def globals
      self['_global']
    end

    private

    def load_config!
      if File.exists?("#{path}/config/pieces.yml")
        merge!(YAML.load_file("#{path}/config/pieces.yml"))
      else
        raise ConfigNotFound.new("We could not find pieces.yml in #{path}/config/")
      end
    end
  end
end
