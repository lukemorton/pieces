describe Tilt::MustacheTemplate do
  let(:template) { described_class.new('examples/original/app/views/posts/post.html.mustache') }

  context 'when rendering with no data' do
    subject { template.render }
    it { is_expected.to include('<h1 class="post__title"></h1>') }
  end

  context 'when rendering with hash' do
    subject { template.render(title: 'A title') }
    it { is_expected.to include('<h1 class="post__title">A title</h1>') }
  end

  context 'when rendering with an object' do
    subject { template.render(OpenStruct.new(title: 'Another title')) }
    it { is_expected.to include('<h1 class="post__title">Another title</h1>') }
  end
end
