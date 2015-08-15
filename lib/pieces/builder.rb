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
      @route_config ||= YAML.load_file("#{path}/config/pieces.yml")
      require 'pieces/tilt_extension'
    end

    def build
      save_files(build_routes(build_styles))
    end

    private

    def build_styles(files = {})
      compiled_css = Server.new(path: path).sprockets_env['pieces.css']
      files.merge('assets/pieces.css' => { type: 'css', contents: compiled_css })
    end

    def build_routes(files = {})
      route_compiler = RouteCompiler.new(path: path, globals: route_config['_global'])

      routes.reduce(files) do |files, (name, route)|
        route_compiler.compile(files, name, route)
      end
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
