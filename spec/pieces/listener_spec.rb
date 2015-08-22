describe Pieces::Listener do
  within_tmp_dir
  silence_output

  context 'when first listening' do
    subject do
      Pieces::Generator.init
      Pieces::Listener.listen
      Dir['build/*']
    end

    it { is_expected.to_not be_empty }
  end
end
