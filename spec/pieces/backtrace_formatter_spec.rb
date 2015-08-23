describe Pieces::BacktraceFormatter do
  subject do
    begin
      raise RuntimeError.new('Uh oh')
    rescue RuntimeError => e
      described_class.new(double(path: 'nice')).format(e)
    end
  end

  it { is_expected.to include('Exception<RuntimeError>: Uh oh') }
end
