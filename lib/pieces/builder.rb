require 'ostruct'
require 'yaml'

module Pieces
  class Builder
    def build(config)
      Dir.chdir(config[:path]) do
        save_files(build_files)
      end
    end

    private

    def build_files
      routes.reduce({}) { |files, (name, route)| build_route(files, name, route) }
    end

    def route_config
      @route_config ||= YAML.load_file('config/routes.yml')
    end

    def globals
      route_config['_global'] or {}
    end

    def routes
      route_config.reject { |key, _| key =~ /^_/ }
    end

    def build_route(files, name, route)
      StyleCompiler.new.compile(files)
      RouteCompiler.compile(files, name, route, globals)
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
