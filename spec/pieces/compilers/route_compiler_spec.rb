describe Pieces::RouteCompiler do
  let(:compiler) { described_class.new(path: 'examples/original/') }

  context 'when compiling about.html' do
    subject do
      compiler.compile({}, :index, route_config)['index.html'][:contents]
    end

    context 'with several pieces' do
      let(:content) do
        [{ 'header' => { title: 'A header' } },
         { 'posts/post' => { title: 'About Author',
                             content: '<p>He is a cool dude.</p>' } }]
      end

      let(:route_config) do
        { '_pieces' => [{ 'layouts/layout' => { '_pieces' => content } }] }
      end

      it { is_expected.to include("<header>\n  A header\n</header>") }
      it { is_expected.to include('<h1 class="post__title">About Author</h1>') }
      it { is_expected.to include('<div class="post__content">') }
      it { is_expected.to include('<p>He is a cool dude.</p>') }
    end

    context 'with nested pieces' do
      let(:content) do
        [{ 'posts' => { '_pieces' => [{ 'posts/post' => { title: 'About Author',
                                                         content: '<p>He is a cool dude.</p>' } }] } }]
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
          '_pieces' => [{ 'layouts/layout' => { '_pieces' => [{ 'posts/post' => {} }] } }] }
      end

      it { is_expected.to include('<h1 class="post__title">Global title</h1>') }
    end

    context 'when using nested global variables' do
      let(:route_config) do
        { '_global' => { 'title' => 'Global title' },
          '_pieces' => [{ 'layouts/layout' => { '_global' => { 'title' => 'Nested global title' },
                                                '_pieces' => [{ 'posts/post' => {} }] } }] }
      end

      it { is_expected.to include('<h1 class="post__title">Nested global title</h1>') }
    end
  end

  context 'when compiling with rails helpers' do
    let(:sprockets_env) { Pieces::Server.new(path: 'examples/rails_app/').sprockets_env }
    let(:compiler) { described_class.new(path: 'examples/rails_app/', env: sprockets_env) }

    let(:route_config) do
      { '_pieces' => [{ 'layouts/pieces' => {} }] }
    end

    subject do
      compiler.compile({}, :index, route_config)['index.html'][:contents]
    end

    it { is_expected.to include('<link rel="stylesheet" media="screen" href="/assets/pieces.css" />') }
  end
end
