describe Pieces::Publisher do
  silence_output

  context 'when publishing to github pages' do
    let(:remote_dir) do
      Dir.mktmpdir.tap do |remote_dir|
        commands = ['git init',
                    'touch example.txt',
                    'git add .',
                    'git commit -m "First"',
                    'git checkout -b gh-pages',
                    'git checkout master']
        system(commands.join(' && '), chdir: remote_dir, [:out, :err] => '/dev/null')
      end
    end

    let(:config) do
      Pieces::Config.new(path: 'examples/rails_app/').tap do |config|
        config['_publish'].first['remote'] = remote_dir
      end
    end

    before(:each) { described_class.new(config).publish }
    after(:each) { FileUtils.rm_rf(remote_dir) }

    subject { %x{cd #{remote_dir} && git checkout -q gh-pages && git log} }

    it { is_expected.to include('First') }
    it { is_expected.to include('Commit all the things') }
  end

  context 'when publishing config missing' do
    subject { described_class.publish(path: 'examples/original/') }
    it { expect { subject }.to raise_error(Pieces::PublisherConfigNotFound) }
  end
end
