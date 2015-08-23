require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pieces'
require 'pry-byebug'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../examples/rails_app/config/environment.rb',  __FILE__)
require 'rspec/rails'
require 'capybara/rails'

RAILS_APP = Capybara.app
ROOT_DIR = File.dirname(__FILE__) + '/../'

shared_examples_for 'it is expected to contain boilerplate files' do
  it { is_expected.to include('config/pieces.yml') }
  it { is_expected.to include('app/assets/stylesheets/pieces.css') }
  it { is_expected.to include('app/views/layouts/pieces.html.erb') }
  it { is_expected.to include('app/views/application/header.html.erb') }
  it { is_expected.to include('app/views/application/footer.html.erb') }
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

module SilenceOutput
  def silence_output
    before(:each) do
      allow($stdout).to receive(:write)
      allow($stderr).to receive(:write)
    end
  end
end

RSpec.configure do |config|
  config.extend(TmpDir)
  config.extend(SilenceOutput)
end
