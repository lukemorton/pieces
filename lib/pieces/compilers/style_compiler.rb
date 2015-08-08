module Pieces
  module StyleCompiler
    extend self

    def compile(files)
      files['compiled.css'] = { contents: '', type: 'css' }

      Dir["pieces/*/*.{css,scss,sass,less}"].each do |file|
        files['compiled.css'][:contents] << Tilt.new(file).render
      end
    end
  end
end
