require 'ostruct'
require 'yaml'

module Pieces
  class Builder
    attr_reader :path
    attr_reader :route_config

    def initialize(config)
      @path = config[:path]
      @route_config ||= YAML.load_file("#{path}/config/routes.yml")
    end

    def build
      Dir.chdir(path) do
        save_files(build_files)
      end
    end

    private

    def build_files
      files = {}
      StyleCompiler.new.compile(files)

      routes.reduce(files) do |files, (name, route)|
        RouteCompiler.compile(files, name, route, globals)
      end
    end

    def globals
      route_config['_global'] or {}
    end

    def routes
      route_config.reject { |key, _| key =~ /^_/ }
    end

    def save_files(files)
      FileUtils.rm_rf('build')
      Dir.mkdir('build')

      files.each do |name, file|
        save_file(name, file)
      end
    end

    def save_file(name, file)
      FileUtils.mkdir_p(File.dirname("build/#{name}"))
      File.open("build/#{name}", 'w') { |f| f.write(file[:contents]) }
    end
  end
end
