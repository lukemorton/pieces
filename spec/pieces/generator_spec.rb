describe Pieces::Generator do
  context 'when test_app is generated' do
    around(:each) do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir, &example)
      end
    end

    shared_examples_for 'it is expected to contain built files' do
      it { is_expected.to include('config/routes.yml') }
      it { is_expected.to include('pieces/layouts/application.html.erb') }
      it { is_expected.to include('pieces/application/header.html.erb') }
      it { is_expected.to include('pieces/application/footer.html.erb') }
    end

    context 'test_app/' do
      subject do
        described_class.init(path: 'test_app')

        Dir.chdir('test_app') do
          Dir['**/*']
        end
      end

      include_examples 'it is expected to contain built files'
    end

    context 'unspecified directory' do
      subject do
        Dir.mkdir('test_app')
        Dir.chdir('test_app') do
          described_class.init
          Dir['**/*']
        end
      end

      include_examples 'it is expected to contain built files'
    end
  end
end
