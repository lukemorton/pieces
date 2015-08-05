describe Pieces::Builder do
  before(:each) { described_class.new.build(path: 'example') }
  after(:each) { FileUtils.rm_rf('example/build') }

  context 'when building example site' do
    subject { Dir['example/build/*'] }
    it { is_expected.to_not be_empty }
  end

  context 'when compiling index.html from Mustache templates' do
    let(:index_html) { File.read('example/build/index.html') }

    def index_template(title, content)
      %Q{<article class="post">
  <h1 class="post__title">#{title}</h1>

  <div class="post__content">
    #{content}
  </div>
</article>}
    end

    subject { index_html }

    it { is_expected.to include(index_template('A block title', '<p>Some paragraph</p>')) }
  end

  context 'when building CSS' do
    let(:css) { File.read('example/build/compiled.css') }

    it 'should compile all CSS in pieces referenced in routes.yml' do
      expect(css).to eq(".post {\n  padding: 1em;\n}\n")
    end
  end
end
