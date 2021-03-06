require 'pieces/cli'

describe Pieces::CLI do
  within_tmp_dir
  silence_output

  context 'when checking version of pieces' do
    %w(version --version -v).each do |command|
      context "with `pieces #{command}`" do
        subject { Pieces::CLI.start([command]) }
        it { expect { subject }.to output("pieces v#{Pieces::VERSION}\n").to_stdout }
      end
    end
  end

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
      it { is_expected.to include('assets/pieces.css') }
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
      it { is_expected.to include('assets/pieces.css') }
    end
  end
end
