describe Pieces::Server do
  let(:server) { described_class.new(path: 'examples/original') }

  context 'when running developent server', type: :feature do
    before(:each) do
      Pieces::Builder.new(path: 'examples/original').build
      Capybara.app = server.app
    end

    after(:each) do
      Capybara.app = RAILS_APP
      FileUtils.rm_rf('examples/original/build/')
    end

    it 'should render without errors' do
      visit '/'
      expect(page).to have_content('A block title')
    end
  end
end
