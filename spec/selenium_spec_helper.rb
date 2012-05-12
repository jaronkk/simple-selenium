require "selenium/selenium_helper"
require "ruby-debug"

RSpec.configure do |config|
  config.include SeleniumHelper

  config.before(:all) do
    selenium_start
  end

  config.after(:all) do
    selenium_quit
  end
end