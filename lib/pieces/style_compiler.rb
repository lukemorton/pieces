module StyleCompiler
  extend self

  def compile(files)
    Dir["pieces/*/*.{css,scss,sass,less}"].each do |file|
      files['compiled.css'] = { contents: '', type: 'css', compiled: [] } unless files.has_key?('compiled.css')

      unless files['compiled.css'][:compiled].include?(file)
        files['compiled.css'][:contents] << Tilt.new(file).render
        files['compiled.css'][:compiled] << file
      end
    end
  end
end
