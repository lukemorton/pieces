module Pieces
  module Generator
    extend self

    def init(config = {})
      path = config[:path] || Dir.pwd
      FileUtils.mkdir_p(path)

      if Dir.exist?("#{path}/app/views")
        FileUtils.mkdir_p("#{path}/app/views/application")

        unless File.exist?("#{path}/app/views/layouts/pieces.html.erb")
          FileUtils.cp("#{example_path}/app/views/layouts/pieces.html.erb", "#{path}/app/views/layouts")
        end

        unless File.exist?("#{path}/app/views/application/header.html.erb")
          FileUtils.cp("#{example_path}/app/views/application/header.html.erb", "#{path}/app/views/application")
        end

        unless File.exist?("#{path}/app/views/application/footer.html.erb")
          FileUtils.cp("#{example_path}/app/views/application/footer.html.erb", "#{path}/app/views/application")
        end
      else
        FileUtils.cp_r("#{example_path}/app/views", path)
      end

      unless File.exist?("#{path}/config/pieces.yml")
        FileUtils.mkdir_p("#{path}/config")
        FileUtils.cp("#{example_path}/config/pieces.yml", "#{path}/config/pieces.yml")
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
