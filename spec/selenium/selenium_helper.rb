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
      element?(:xpath, "//*[contains(., #{escape_xpath_text(text)})]")
    end

    def element?(*args)
      find_element(*args)
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      false
    end

    def wait_for_element(*args)
      wait.until { find_element(*args) }
    end

    def wait
      @wait ||= Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
    end

    def escape_xpath_text(text)
      if text =~ /"/
        # The only way to effectively allow quotes in xpath text is by using the concat function to join strings together
        "concat(\"" + text.gsub(/"/,"\", '\"', \"") + "\")"
      else
        "\"#{text}\""
      end
    end
  end
end