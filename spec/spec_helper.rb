$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'pieces'

shared_examples_for 'it is expected to contain built files' do

shared_examples_for 'it is expected to contain boilerplate files' do
  it { is_expected.to include('config/routes.yml') }
  it { is_expected.to include('pieces/layouts/application.html.erb') }
  it { is_expected.to include('pieces/application/header.html.erb') }
  it { is_expected.to include('pieces/application/footer.html.erb') }
end

module TmpDir
  def within_tmp_dir
    around(:each) do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir, &example)
      end
    end
  end
end

RSpec.configure do |config|
  config.extend(TmpDir)
end
