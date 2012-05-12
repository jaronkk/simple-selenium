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

  describe "form manipulation on Google" do
    it "should search Google by pressing the enter key" do
      expected_link_title = "Test - Wikipedia, the free encyclopedia"
      selenium.get("https://www.google.com")
      # Google's main search input field has an id of "gbqfq" for now
      search_field = selenium.find_element(:id, "gbqfq")
      search_field.attribute(:value).should == ""
      # Type "Test", then press the return key
      search_field.send_keys "Test", :return
      search_field.attribute(:value).should == "Test"
      # Since it takes a little while for the search to run, we expect that our link is not present immediately
      selenium.element?(:link, expected_link_title).should be_false
      # Use the wait_for_element method to wait until our link appears
      link = selenium.wait_for_element(:link, expected_link_title)
      # Verify that the link goes where we expect
      link.attribute(:href).should == "http://en.wikipedia.org/wiki/Test"
    end

    it "should search Google by clicking the search button" do
      expected_link_title = "Test - Wikipedia, the free encyclopedia"
      selenium.get("https://www.google.com")
      # Google's main search input field also has the name of "q", so we can use XPath to find it
      search_field = selenium.find_element(:xpath, "//input[@name=\"q\"]")
      # Type "Test", this time passing each letter separately (just as an example of how send_keys works)
      search_field.send_keys "T", "e", "s", "t"
      # Since "Test" is a short search with a lot of results, Google should not yet be automatically searching
      selenium.wait_for_text("Press Enter to search.").should be_true
      # Find the search button then click it
      search_button = selenium.find_element(:xpath, "//button[@name=\"btnG\"]")
      search_button.displayed?.should be_true
      search_button.click
      # Use the wait_for_element method to wait until our link appears
      link = selenium.wait_for_element(:link, expected_link_title)
      # Verify that the link goes where we expect
      link.attribute(:href).should == "http://en.wikipedia.org/wiki/Test"
      # Now that the results are on the page, the message telling us how to search should be gone
      selenium.text?("Press Enter to search.").should be_false
    end
  end

  describe "Navigating multiple pages" do
    it "Should add an Amazon gift card to the cart" do
      selenium.get("http://www.amazon.com")
      selenium.find_element(:link, "Gift Cards").click
      selenium.find_element(:link, "E-mail").click
      # Make sure we're on the right page
      selenium.text?("Your eGift Card Order is empty.").should be_true
      # Use a css selector to find the first select button to select the gift card design
      selenium.find_element(:css, "input.gcSelectButton").click
      # Set the amount of the gift card, recipient name and email, sender name, and message
      selenium.find_element(:css, "input[name=amount]").send_keys("99")
      selenium.find_element(:id, "s-to-Email").send_keys("John Doe")
      selenium.find_element(:id, "s-email-Email").send_keys("john@example.com")
      selenium.find_element(:id, "s-from-Email").send_keys("Nice Guy")
      message = selenium.find_element(:id, "s-message-Email")
      message.send_keys("Hey John,\nI know I'm your last resort and that you needed $100 even for that heart transplant, but I could only spare $99.\n\nHope this helps,\n-- Nice")
      # Add it to the cart!
      selenium.find_element(:id, "add-to-cart-Email").click
      # Verify that the gift card has been added.
      selenium.wait_for_text("$99.00").should be_true
    end
  end
end