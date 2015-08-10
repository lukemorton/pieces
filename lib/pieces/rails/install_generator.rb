module Pieces
  class Rails
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../../../../examples', __FILE__)

      def pieces_yml
        copy_file 'rails_app/config/pieces.yml', 'config/pieces.yml'
      end

      def stylesheet
        copy_file 'rails_app/app/assets/stylesheets/pieces.css', 'app/assets/stylesheets/pieces.css'
      end

      def views
        copy_file 'rails_app/app/views/layouts/pieces.html.erb', 'app/views/layouts/pieces.html.erb'
        copy_file 'rails_app/app/views/application/_header.html.erb', 'app/views/application/_header.html.erb'
      end

      def mount_styleguide
        route "mount Pieces::Rails.new.mount, at: '/styleguide' unless Rails.env.production?"
      end

      def gitignore
        append_to_file '.gitignore', 'build/'
      end
    end
  end
end
