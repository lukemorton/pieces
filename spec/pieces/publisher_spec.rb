describe Pieces::Publisher do
  silence_output

  context 'when publishing to github pages' do
    subject do
      described_class.new(path: 'examples/rails_app/').publish
      Net::HTTP.get_response(URI('http://drpheltright.github.io/pieces/'))
    end

    it { is_expected.to be_a(Net::HTTPSuccess) }
  end

  context 'when publishing config missing' do
    subject { described_class.new(path: 'examples/original/').publish }
    it { expect { subject }.to raise_error(Pieces::PublisherConfigNotFound) }
  end
end
