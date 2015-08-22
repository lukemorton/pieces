describe Pieces::Builder do
  before(:each) { described_class.build(path: 'examples/original/') }
  after(:each) { FileUtils.rm_rf('examples/original/build') }

  context 'when example site is built' do
    context 'build/' do
      subject do
        Dir.chdir('examples/original/build/') do
          Dir['**/*']
        end
      end

      it { is_expected.to include('index.html') }
      it { is_expected.to include('about.html') }
      it { is_expected.to include('assets/pieces.css') }
    end
  end

  context 'when pieces.yml cannot be found' do
    subject { described_class.build }
    it { expect { subject }.to raise_error(Pieces::ConfigNotFound) }
  end
end
