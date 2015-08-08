describe Pieces::RouteCompiler do
  let(:compiler) { described_class.new(path: 'examples/original/') }

  context 'when compiling about.html' do
    subject do
      compiler.compile({}, :index, route_config)['index.html'][:contents]
    end

    context 'and nesting pieces' do
      let(:content) do
        [{ 'header' => {} },
         { 'posts/post' => { title: 'About Author',
                             content: '<p>He is a cool dude.</p>' } },
         { 'footer' => {} }]
      end

      let(:route_config) do
        { '_pieces' => [{ 'layouts/layout' => { '_pieces' => content } }] }
      end

      it { is_expected.to include('<h1 class="post__title">About Author</h1>') }
      it { is_expected.to include('<div class="post__content">') }
      it { is_expected.to include('<p>He is a cool dude.</p>') }
    end

    context 'when using global variables' do
      let(:route_config) do
        { '_global' => { 'title' => 'Global title' },
          '_pieces' => [{ 'layouts/layout' => { '_pieces' => [{ 'header' => {} },
                                                              { 'posts/post' => {} },
                                                              { 'footer' => {} }] } }] }
      end

      it { is_expected.to include('<h1 class="post__title">Global title</h1>') }
    end

    context 'when using nested global variables' do
      let(:route_config) do
        { '_global' => { 'title' => 'Global title' },
          '_pieces' => [{ 'layouts/layout' => { '_global' => { 'title' => 'Nested global title' },
                                                '_pieces' => [{ 'header' => {} },
                                                              { 'posts/post' => {} },
                                                              { 'footer' => {} }] } }] }
      end

      it { is_expected.to include('<h1 class="post__title">Nested global title</h1>') }
    end
  end
end
