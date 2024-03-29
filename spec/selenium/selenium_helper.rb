require "selenium-webdriver"

module SeleniumHelper
  def selenium
    if @selenium_driver.nil?
      selenium_initialize
    end

    @selenium_driver
  end

  def selenium_initialize
    @selenium_driver = SeleniumRSpecWrapper.new
  end

  def selenium_quit
    if @selenium_driver
      @selenium_driver.quit
      @selenium_driver = nil
    end
  end

  class SeleniumRSpecWrapper
    def initialize
      # Lazy load the actual Selenium WebDriver driver
      @driver = nil
    end

    def initialize_driver
      @driver = Selenium::WebDriver.for :firefox
      @driver.manage.timeouts.implicit_wait = 0
    end

    def quit
      if @driver
        @driver.quit
      end
    end

    def method_missing(method_name, *args, &block)
      if @driver.nil?
        initialize_driver
      end
      @driver.send(method_name, *args, &block)
    end

    def text?(text)
      text_xpath = "//*[text()[contains(., #{escape_xpath_text(text)})]]"
      elements = find_elements(:xpath, text_xpath)
      elements = elements.reject{|e| !e.displayed?}
      elements.size > 0
    end

    def wait_for_text(text)
      wait.until { text?(text) }
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