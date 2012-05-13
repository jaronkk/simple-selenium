require "selenium/selenium_helper"

RSpec.configure do |config|
  config.include SeleniumHelper

  config.before(:all) do
    selenium_initialize
  end

  config.after(:all) do
    selenium_quit
  end
end