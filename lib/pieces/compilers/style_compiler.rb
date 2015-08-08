module Pieces
  class StyleCompiler
    attr_reader :path

    def initialize(config = {})
      @path = config[:path] || Dir.pwd
    end

    def compile(files)
      files['compiled.css'] = { contents: '', type: 'css' }

      Dir["#{path}/pieces/*/*.{css,scss,sass,less}"].each do |file|
        files['compiled.css'][:contents] << Tilt.new(file).render
      end

      files
    end
  end
end
