require 'yaml'

module Pieces
  class Builder
    def build(config)
      Dir.chdir(config[:path]) do
        save_files(routes.reduce({}) { |files, (name, route)| build_route(files, name, route) })
      end
    end

    private

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
      route['_pieces'].reduce(files) do |files, piece|
        piece, data = piece.keys.first, piece.values.first
        data['_global'] = globals.merge(route.delete('_global') || {}).merge(data['_global'] || {})

        Dir["pieces/*/*.{css,scss,sass,less}"].each do |file|
          files['compiled.css'] = { contents: '', type: 'css', compiled: [] } unless files.has_key?('compiled.css')

          unless files['compiled.css'][:compiled].include?(file)
            files['compiled.css'][:contents] << Tilt.new(file).render
            files['compiled.css'][:compiled] << file
          end
        end

        files["#{name}.html"] = { contents: '', type: 'html' } unless files.has_key?("#{name}.html")
        content = Tilt.new(piece_path(piece)).render(data['_global'].merge(data)) { yield_route_pieces(data) }
        files["#{name}.html"][:contents] << content

        files
      end
    end

    def piece_path(piece)
      Dir["pieces/{#{piece},#{piece}/#{piece},application/#{piece}}.html.*"].first
    end

    def yield_route_pieces(parent_data)
      return '' unless parent_data.has_key?('_pieces')

      parent_data['_pieces'].reduce('') do |content, piece|
        piece, data = piece.keys.first, piece.values.first
        data['_global'] = (parent_data['_global'] || {}).merge(data['_global'] || {})
        content << Tilt.new(piece_path(piece)).render(data['_global'].merge(data)) { yield_route_pieces(data) }
      end
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
