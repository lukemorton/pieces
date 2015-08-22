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
        Pieces::Builder.new(path: config.path,
                            config: config)
      end
    end

    class Github < Adapter
      def publish
        FileUtils.rm_rf("#{config.path}/build/")
        builder.build
        system(commands.join(' && '), chdir: "#{config.path}/build/")
      end

      protected

      def asset_prefix
        _, username, repo = URI(config.publish_endpoint['remote']).path.split('/')
        repo = File.basename(repo, '.git')
        "http://#{username}.github.io/#{repo}/assets"
      end

      private

      def commands
        ['git init',
         "git remote add github #{config.publish_endpoint['remote']}",
         "git checkout -b gh-pages",
         "git add .",
         "git commit -m 'Commit all the things'",
         "git push -f github gh-pages"]
      end
    end
  end
end
