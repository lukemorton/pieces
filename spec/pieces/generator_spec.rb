describe Pieces::Generator do
  context 'when test_app is generated' do
    within_tmp_dir
    silence_output

    context 'test_app/' do
      subject do
        described_class.init(path: 'test_app')

        Dir.chdir('test_app') do
          Dir['**/*']
        end
      end

      include_examples 'it is expected to contain boilerplate files'
    end

    context 'unspecified directory' do
      subject do
        Dir.mkdir('test_app')

        Dir.chdir('test_app') do
          described_class.init
          Dir['**/*']
        end
      end

      include_examples 'it is expected to contain boilerplate files'
    end
  end
end
