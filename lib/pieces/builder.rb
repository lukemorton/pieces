require 'ostruct'
require 'yaml'
require 'sprockets'
require 'pieces/compilers/route_compiler'
require 'pieces/config'
require 'pieces/server'
require 'pieces/tilt_extension'

module Pieces
  class Builder
    def self.build(config = {})
      new(Config.new(config)).build
    end

    include Configurable

    def initialize(config)
      super
      config.env = env
    end

    def build
      save_files(build_routes(build_styles))
    end

    private

    def env
      @env ||= Server.new(config).sprockets_env
    end

    def build_styles(files = {})
      files.merge('assets/pieces.css' => { type: 'css', contents: env['pieces.css'] })
    end

    def build_routes(files = {})
      route_compiler = RouteCompiler.new(config)

      config.routes.reduce(files) do |files, (name, route)|
        route_compiler.compile(files, name, route)
      end
    end

    def save_files(files)
      Dir.chdir(config.path) do
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
