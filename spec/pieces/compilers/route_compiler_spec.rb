describe Pieces::RouteCompiler do
  let(:config) do
    Pieces::Config.new(path: path).tap do |config|
      config.env = Pieces::Server.new(config).sprockets_env
    end
  end

  let(:compiler) { described_class.new(config) }

  context 'when compiling about.html' do
    let(:path) { 'examples/original/' }
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
    let(:path) { 'examples/rails_app/' }

    let(:route_config) do
      { '_pieces' => [{ 'layouts/pieces' => {} }] }
    end

    subject do
      compiler.compile({}, :index, route_config)['index.html'][:contents]
    end

    it { is_expected.to include('<link rel="stylesheet" media="screen" href="/assets/pieces.css" />') }
  end
end
