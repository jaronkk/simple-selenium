require "selenium-webdriver"
require "ruby-debug"
require "selenium_helper"

RSpec.configure do |config|
  config.include SeleniumHelper

  config.before(:all) do
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.timeouts.implicit_wait = 10
  end

  config.after(:all) do
    @driver.quit
  end
end