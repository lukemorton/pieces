describe Pieces::Builder do
  context 'when building example site' do
    subject { Dir['example/build/*'] }
    before(:each) { described_class.new.build(path: 'example') }
    it { is_expected.to_not be_empty }
  end
end
