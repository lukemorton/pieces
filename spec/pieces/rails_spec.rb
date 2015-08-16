describe Pieces::Rails, type: :feature do
  context 'when booting rails server' do
    it 'should make styleguide available via routes' do
      visit '/styleguide'
      expect(page).to have_content 'Building systems with styleguides'
    end
  end
end
