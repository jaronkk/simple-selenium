require "selenium_spec_helper"

describe "selenium webdriver examples" do
  describe "basics" do
    it "should open a page and read the title" do
      selenium.get("https://www.google.com")
      selenium.title.should == "Google"
    end

    it "should open a 404 page and read the title" do
      selenium.get("http://www.google.com/foo")
      selenium.title.should =~ /Error 404/
    end
  end

  describe "text search" do
    it "should correctly search with quotation marks" do
      selenium.get("http://en.wikipedia.org/wiki/Quotation_mark")
      selenium.text?("'Good morning, Frank,' said Hal.").should be_true
      selenium.text?("\"Good morning, Frank,\" said Hal.").should be_true
      selenium.text?("'Hal said, \"Good morning, Dave,\"' recalled Frank.").should be_true
    end
  end

  describe "form manipulation" do
    it "should search Google" do
      selenium.get("https://www.google.com")
      search_field = selenium.find_element(:id, "gbqfq")
      search_field.send_keys "Test", :return
      link = selenium.wait_for_element(:link, "Test - Wikipedia, the free encyclopedia")
      link.attribute(:href).should == "http://en.wikipedia.org/wiki/Test"
    end
  end
end