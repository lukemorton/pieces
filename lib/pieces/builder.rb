require 'ostruct'
require 'yaml'
require 'sprockets'
require 'pieces/compilers/route_compiler'
require 'pieces/server'
require 'pieces/tilt_extension'

module Pieces
  class Builder
    def self.build(config)
      new(config).build
    end

    attr_reader :path

    def initialize(config)
      @path = config[:path]
    end

    def build
      save_files(build_routes(build_styles))
    end

    private

    def route_config
      @route_config ||= begin
        unless File.exists?("#{path}/config/pieces.yml")
          puts "We could not find pieces.yml in #{path}/config/"
          puts 'Sorry about that!'
          exit(1)
        end

        YAML.load_file("#{path}/config/pieces.yml")
      end
    end

    def env
      @env ||= Server.new(path: path).sprockets_env
    end

    def build_styles(files = {})
      files.merge('assets/pieces.css' => { type: 'css', contents: env['pieces.css'] })
    end

    def build_routes(files = {})
      route_compiler = RouteCompiler.new(path: path,
                                         globals: route_config['_global'],
                                         env: env)

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
