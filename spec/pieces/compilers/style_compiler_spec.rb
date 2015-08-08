describe Pieces::StyleCompiler do
  let(:compiler) { described_class.new(path: 'examples/original/') }

  context 'when building compiled.css' do
    subject { compiler.compile({})['compiled.css'][:contents] }
    it { is_expected.to eq(".post {\n  padding: 1em;\n}\n") }
  end
end
