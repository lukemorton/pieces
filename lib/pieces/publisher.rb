require 'open3'

module Pieces
  class PublisherConfigNotFound < RuntimeError; end

  class Publisher
    attr_reader :path

    def initialize(config)
      @path = config[:path]
    end

    def publish
      publisher_class.new(path: path, config: config, publish_config: publish_config).publish
    end

    private

    def config
      @config ||= Pieces::Config.new(path: path)
    end

    def publisher_class
      self.class.const_get(publish_config['type'].capitalize)
    end

    def publish_config
      if config['_publish'].nil? or config['_publish'].empty?
        raise PublisherConfigNotFound
      end

      config['_publish'].first
    end

    class Adapter
      attr_reader :path, :config, :publish_config

      def initialize(config)
        @path = config[:path]
        @config = config[:config]
        @publish_config = config[:publish_config]
      end

      protected

      def asset_prefix
      end

      def builder
        Pieces::Builder.new(path: path, config: config, asset_prefix: asset_prefix)
      end
    end

    class Github < Adapter
      def publish
        FileUtils.rm_rf("#{path}/build/")

        builder.build

        system(commands.join(' && '), chdir: "#{path}/build/")
        #  do |stdin, stdout, stderr, wait_thr|
        #   puts stdout
        #   puts stderr
        # end
      end

      protected

      def asset_prefix
        _, username, repo = URI(publish_config['remote']).path.split('/')
        repo = File.basename(repo, '.git')
        "http://#{username}.github.io/#{repo}/assets"
      end

      private

      def commands
        ['git init',
         "git remote add github #{publish_config['remote']}",
         "git checkout -b gh-pages",
         "git add .",
         "git commit -m 'Commit all the things'",
         "git push -f github gh-pages"]
      end
    end
  end
end
