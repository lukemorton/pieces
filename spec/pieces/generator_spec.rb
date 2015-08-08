describe Pieces::Generator do
  context 'when test_app is generated' do
    around(:each) do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir, &example)
      end
    end

    context 'test_app/' do
      subject do
        described_class.init(path: 'test_app')

        Dir.chdir('test_app') do
          Dir['**/*']
        end
      end

      it { is_expected.to include('config/routes.yml') }
      it { is_expected.to include('pieces/layouts/application.html.erb') }
      it { is_expected.to include('pieces/application/header.html.erb') }
      it { is_expected.to include('pieces/application/footer.html.erb') }
    end
  end
end
