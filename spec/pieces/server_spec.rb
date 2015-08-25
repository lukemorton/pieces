describe Pieces::Server do
  let(:server) { described_class.new(Pieces::Config.new(path: 'examples/original')) }

  context 'when running developent server', type: :feature do
    before(:each) do
      Capybara.app = server.app
    end

    after(:each) do
      Capybara.app = RAILS_APP
    end

    it 'should render without errors' do
      visit '/'
      expect(page).to have_content('A block title')
    end
  end
end
