require "selenium-webdriver"

module SeleniumHelper
  def selenium
    if @selenium_driver.nil?
      selenium_start
    end

    @selenium_driver
  end

  def selenium_start
    @selenium_driver = SeleniumRSpecWrapper.new
  end

  def selenium_quit
    if @selenium_driver
      @selenium_driver.quit
    end
  end

  class SeleniumRSpecWrapper
    def initialize
      @driver = Selenium::WebDriver.for :firefox
      @driver.manage.timeouts.implicit_wait = 0
    end

    def method_missing(method_name, *args, &block)
      @driver.send(method_name, *args, &block)
    end

    def text?(text)
      begin
        @driver.find_element(:xpath, "//*[contains(., \"#{text}\")]")
        true
      rescue Selenium::WebDriver::Error::NoSuchElementError
        false
      end
    end
  end
end