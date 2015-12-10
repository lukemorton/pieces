require 'ostruct'
require 'yaml'
require 'sprockets'

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
      save_files(build_routes(build_assets))
    end

    private

    def env
      @env ||= Server.new(config).sprockets_env
    end

    def manifest
      @manifest ||= Sprockets::Manifest.new(env, 'build/assets')
    end

    def build_assets(files = {})
      if env['manifest.js']
        manifest.find('manifest.js').reduce(files) do |files, file|
          files.merge("assets/#{file.logical_path}" => { type: file.content_type, contents: file })
        end
      else
        files.merge('assets/pieces.css' => { type: 'text/css', contents: env['pieces.css'] },
                    'assets/pieces.js' => { type: 'application/js', contents: env['pieces.js'] })
      end
    end

    def build_routes(files = {})
      route_compiler = RouteCompiler.new(config)

      config.routes.reduce(files) do |files, (name, route)|
        route_compiler.compile(files, name, route)
      end
    end

    def save_files(files)
      Dir.chdir(config.path) do
        files.each(&method(:save_file))
      end
    end

    def save_file(name, file)
      FileUtils.mkdir_p(File.dirname("build/#{name}"))
      File.open("build/#{name}", 'w') { |f| f.write(file[:contents]) }
    end
  end
end
