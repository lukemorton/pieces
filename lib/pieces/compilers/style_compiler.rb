module Pieces
  class StyleCompiler
    attr_reader :path

    def initialize(config = {})
      @path = config[:path] || Dir.pwd
    end

    def compile(files)
      files.merge('compiled.css' => { contents: '', type: 'css' }).tap do |files|
        Dir["#{path}/pieces/*/*.{css,scss,sass,less}"].each do |file|
          files['compiled.css'][:contents] << Tilt.new(file).render
        end
      end
    end
  end
end
