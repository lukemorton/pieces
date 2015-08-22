describe Pieces::Rails, type: :feature do
  context 'when booting rails server' do
    before(:each) do
      Pieces::Builder.build(path: 'examples/rails_app/')
    end

    after(:each) do
      FileUtils.rm_rf('examples/rails_app/build/')
    end

    it 'should make styleguide available via routes' do
      visit '/styleguide'
      expect(page).to have_content 'Building systems with styleguides'
    end
  end
end
