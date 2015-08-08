describe Pieces::Builder do
  before(:each) { described_class.new(path: 'examples/original/').build }
  after(:each) { FileUtils.rm_rf('examples/original/build') }

  context 'when example site is built' do
    context 'build/' do
      subject do
        Dir.chdir('examples/original/build/') do
          Dir['*']
        end
      end

      it { is_expected.to include('index.html') }
      it { is_expected.to include('about.html') }
      it { is_expected.to include('compiled.css') }
    end
  end

  context 'when compiling index.html from Mustache templates' do
    let(:index_html) { File.read('examples/original/build/index.html') }

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

end
