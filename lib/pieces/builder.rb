require 'ostruct'
require 'yaml'

module Pieces
  class Builder
    def self.build(config)
      new(config).build
    end

    attr_reader :path
    attr_reader :route_config

    def initialize(config)
      @path = config[:path]
      @route_config ||= YAML.load_file("#{path}/config/routes.yml")
    end

    def build
      save_files(build_files)
    end

    private

    def build_files
      files = {}
      StyleCompiler.new(path: path).compile(files)

      Dir.chdir(path) do
        routes.reduce(files) do |files, (name, route)|
          RouteCompiler.compile(files, name, route, globals)
        end
      end
    end

    def globals
      route_config['_global'] or {}
    end

    def routes
      route_config.reject { |key, _| key =~ /^_/ }
    end

    def save_files(files)
      Dir.chdir(path) do
        FileUtils.rm_rf('build')
        Dir.mkdir('build')

        files.each do |name, file|
          save_file(name, file)
        end
      end
    end

    def save_file(name, file)
      FileUtils.mkdir_p(File.dirname("build/#{name}"))
      File.open("build/#{name}", 'w') { |f| f.write(file[:contents]) }
    end
  end
end
