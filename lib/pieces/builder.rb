require 'yaml'

module Pieces
  class Builder
    def build(config)
      Dir.chdir(config[:path]) do
        files = routes.reduce({}) { |files, (name, route)| build_route(files, name, route) }
        save_files(render_files_in_layout(files))
      end
    end

    private

    def route_config
      @route_config ||= YAML.load_file('config/routes.yml')
    end

    def layout_path
      "layouts/#{route_config['_layout']}.html.mustache"
    end

    def globals
      route_config['_global'] or {}
    end

    def routes
      route_config.reject { |key, _| key =~ /^_/ }
    end

    def build_route(files, name, route)
      route['pieces'].reduce(files) do |files, piece|
        piece, data = piece.keys.first, piece.values.first
        route_globals = globals.merge(route.delete('_global') || {})

        Dir["pieces/#{piece}/*"].each do |file|
          case File.extname(file)
          when '.css', '.scss', '.sass', '.less'
            files['compiled.css'] = { contents: '', type: 'css', compiled: [] } unless files.has_key?('compiled.css')

            unless files['compiled.css'][:compiled].include?(file)
              files['compiled.css'][:contents] << Tilt.new(file).render
              files['compiled.css'][:compiled] << file
            end
          else
            files["#{name}.html"] = { contents: '', type: 'mustache' } unless files.has_key?("#{name}.html")
            files["#{name}.html"][:contents] << Tilt.new(file).render(route_globals.merge(data))
          end
        end

        files
      end
    end

    def save_files(files)
      FileUtils.rm_rf('build')
      Dir.mkdir('build')
      files.each { |name, file| save_file(name, file) }
    end

    def save_file(name, file)
      File.open("build/#{name}", 'w') { |f| f.write(file[:contents]) }
    end

    def render_in_layout(contents)
      Mustache.render(File.read(layout_path), globals.merge(contents: contents))
    end

    def render_files_in_layout(files)
      files.reduce({}) do |files, (name, file)|
        if file[:type] == 'mustache'
          file[:contents] = render_in_layout(file[:contents])
        end

        files.merge(name => file)
      end
    end
  end
end
