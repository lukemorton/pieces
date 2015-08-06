module Pieces
  class Generator
    def init(config)
      FileUtils.mkdir_p(config[:path])

      Dir["#{example_path}/{config,layouts,pieces}"].each do |dir|
        FileUtils.cp_r(dir, config[:path])
      end

      FileUtils.cp("#{example_path}/Gemfile", "#{config[:path]}/Gemfile")
    end

    private

    def example_path
      File.dirname(__FILE__) + '/../../examples/boilerplate'
    end
  end
end
