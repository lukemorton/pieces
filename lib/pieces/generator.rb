module Pieces
  class Generator
    def init(config)
      FileUtils.mkdir_p(config[:path])

      Dir["#{example_path}/{config,layouts,pieces}"].each do |dir|
        FileUtils.cp_r(dir, config[:path])
      end
    end

    private

    def example_path
      File.dirname(__FILE__) + '/../../example'
    end
  end
end
