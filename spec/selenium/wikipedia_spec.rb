require "spec_helper"

describe "wikipedia" do

  it "should open the main page" do
    @driver.get("http://en.wikipedia.org")
    header = @driver.find_element(:xpath, "//h2[contains(., \"Today's featured article\")]")
  end
end