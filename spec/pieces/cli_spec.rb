require 'pieces/cli'

describe Pieces::CLI do
  within_tmp_dir
  silence_output

  context 'when initing new project' do
    context 'test_app/' do
      subject do
        Pieces::CLI.start(%w(init test_app))

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
          Pieces::CLI.start(%w(init))
          Dir['**/*']
        end
      end

      include_examples 'it is expected to contain boilerplate files'
    end
  end

  context 'when building project' do
    context 'test_app/' do
      subject do
        Pieces::Generator.init(path: 'test_app')
        Pieces::CLI.start(%w(build test_app))

        Dir.chdir('test_app/build/') do
          Dir['**/*']
        end
      end

      it { is_expected.to include('index.html') }
      it { is_expected.to include('compiled.css') }
    end

    context 'unspecified directory' do
      subject do
        Pieces::Generator.init(path: 'test_app')

        Dir.chdir('test_app/') do
          Pieces::CLI.start(%w(build))

          Dir.chdir('build/') do
            Dir['**/*']
          end
        end
      end

      it { is_expected.to include('index.html') }
      it { is_expected.to include('compiled.css') }
    end
  end
end
