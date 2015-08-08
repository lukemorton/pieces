module Pieces
  module Generator
    extend self

    def init(config = {})
      path = config[:path] || Dir.pwd
      FileUtils.mkdir_p(path)

      Dir["#{example_path}/{config,layouts,pieces}"].each do |dir|
        FileUtils.cp_r(dir, path)
      end

      FileUtils.cp("#{example_path}/Gemfile", "#{path}/Gemfile")
    end

    private

    def example_path
      File.dirname(__FILE__) + '/../../examples/boilerplate'
    end
  end
end
