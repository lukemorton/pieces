require 'open3'

module Pieces
  class Publisher
    def self.publish(config)
      new(Pieces::Config.new(config)).publish
    end

    include Configurable

    def publish
      publisher_class.new(config).publish
    end

    private

    def publisher_class
      self.class.const_get(config.publish_endpoint['type'].capitalize)
    end

    class Adapter
      include Configurable

      protected

      def asset_prefix
      end

      def builder
        config['_asset_prefix'] = asset_prefix
        Pieces::Builder.new(config)
      end
    end

    class Github < Adapter
      def publish
        FileUtils.rm_rf("#{config.path}/build/")
        FileUtils.mkdir("#{config.path}/build/")
        clone_into_build_dir
        builder.build
        commit_and_push_changes
      end

      protected

      def asset_prefix
        _, username, repo = URI(config.publish_endpoint['remote']).path.split('/')
        repo = File.basename(repo, '.git')
        "http://#{username}.github.io/#{repo}/assets"
      end

      private

      def exec(*commands)
        system(commands.join(' && '), chdir: "#{config.path}/build/")
      end

      def clone_into_build_dir
        exec("git clone -o pieces_github_pages #{config.publish_endpoint['remote']} .",
             "git checkout gh-pages")
      end

      def commit_and_push_changes
        exec("git add .",
             "git commit -m 'Commit all the things'",
             "git push pieces_github_pages gh-pages")
      end
    end
  end
end
