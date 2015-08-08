module Pieces
  module Generator
    extend self

    def init(config = {})
      path = config[:path] || Dir.pwd
      FileUtils.mkdir_p(path)

      Dir["#{example_path}/{config,app}"].each do |dir|
        FileUtils.cp_r(dir, path) unless Dir.exist?("#{path}/#{File.basename(dir)}")
      end

      unless File.exist?("#{path}/Gemfile")
        FileUtils.cp("#{example_path}/Gemfile", "#{path}/Gemfile")
      end
    end

    private

    def example_path
      File.dirname(__FILE__) + '/../../examples/boilerplate'
    end
  end
end
