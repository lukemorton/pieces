describe Pieces::Builder do
  before(:each) { described_class.new.build(path: 'example') }
  after(:each) { FileUtils.rm_rf('example/build') }

  context 'when building example site' do
    subject { Dir['example/build/*'] }
    it { is_expected.to_not be_empty }
  end

  context 'when building CSS' do
    let(:pieces_referenced) { ['post'] }
    let(:css) { File.read('example/build/compiled.css') }

    it 'should compile all CSS in pieces referenced in routes.yml' do
      pieces_referenced.each do |piece|
        expect(css).to eq(".post {\n  padding: 1em;\n}\n")
      end
    end
  end
end
