require "selenium_spec_helper"

describe "selenium webdriver examples" do
  describe "basics" do
    it "should open a page and read the title" do
      selenium.get("https://www.google.com")
      # Check to make sure the title matches exactly
      selenium.title.should == "Google"
    end

    it "should open a 404 page and read the title" do
      selenium.get("http://www.google.com/foo")
      # Check the title using a regular expression this time
      selenium.title.should =~ /Error 404/
    end
  end

  describe "text search" do
    # The text? method uses XPath to determine if given text exists on the page
    # XPath doesn't have the best support for escaption quotation marks, so these tests
    #  exist to make sure the quote escaping works as expected
    it "should correctly search with quotation marks" do
      selenium.get("http://en.wikipedia.org/wiki/Quotation_mark")
      selenium.text?("'Good morning, Frank,' said Hal.").should be_true
      selenium.text?("\"Good morning, Frank,\" said Hal.").should be_true
      selenium.text?("'Hal said, \"Good morning, Dave,\"' recalled Frank.").should be_true
    end
  end

  describe "form manipulation" do
    it "should search Google" do
      expected_link_title = "Test - Wikipedia, the free encyclopedia"
      selenium.get("https://www.google.com")
      # Google's main search input field has an id of "gbqfq" for now
      search_field = selenium.find_element(:id, "gbqfq")
      # Type "Test", then press the return key
      search_field.send_keys "Test", :return
      # Since it takes a little while for the search to run, we don't expect our link to appear right away
      selenium.element?(:link, expected_link_title).should be_false
      # Use the wait_for_element method to wait until our link appears
      link = selenium.wait_for_element(:link, expected_link_title)
      # Verify that the link goes where we expect
      link.attribute(:href).should == "http://en.wikipedia.org/wiki/Test"
    end
  end
end