require 'yaml'
require 'mustache'

module Pieces
  class Builder
    def build(config)
      Dir.chdir(config[:path]) do
        p globals
        save_files(routes.reduce([]) { |files, (name, route)| build_route(files, name, route) })
      end
    end

    private

    def route_config
      @route_config ||= YAML.load_file('config/routes.yml')
    end

    def globals
      route_config.find { |key, _| key == '_global' }.last
    end

    def routes
      route_config.reject { |key, _| key == '_global' }
    end

    def build_route(files, name, route)
      route['pieces'].reduce({}) do |files, piece|
        piece, data = piece.keys.first, piece.values.first

        Dir["pieces/#{piece}/*"].each do |file|
          case File.extname(file)
          when '.mustache'
            files["#{name}.html"] = { contents: '' } unless files.has_key?("#{name}.html")
            files["#{name}.html"][:contents] << Mustache.render(File.read(file), globals.merge(data))
          when '.css'
            files['compiled.css'] = { contents: '' } unless files.has_key?('compiled.css')
            files['compiled.css'][:contents] << File.read(file)
          end
        end

        files.tap { |r| p r }
      end.map { |(name, data)| { name: name }.merge(data) }
    end

    def save_files(files)
      FileUtils.rm_rf('build')
      Dir.mkdir('build')
      files.each { |file| save_file(file) }
    end

    def save_file(file)
      File.open("build/#{file[:name]}", 'w') { |f| f.write(file[:contents]) }
    end
  end
end
