require "test/unit"
require "rubygems"
gem "selenium-webdriver"
require "selenium-webdriver"

class SeleniumTests < Test::Unit::TestCase

  def setup
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "https://www.google.com/"
    @driver.manage.timeouts.implicit_wait = 10
    @verification_errors = []
  end
  
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end
  
  def test_google
    @driver.get(@base_url + "/")
    @driver.find_element(:id, "gbqfq").clear
    @driver.find_element(:id, "gbqfq").send_keys "Test"
    @driver.find_element(:id, "gbqfq").send_keys :return
    @driver.find_element(:link, "Test - Wikipedia, the free encyclopedia").click
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
end
