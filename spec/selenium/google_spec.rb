require "selenium_spec_helper"

describe "google" do

  # it "should open the main page" do
  #   selenium.get("https://www.google.com")
  # end

  it "should open /foo and find a 404" do
    selenium.get("http://www.google.com/foo")
    selenium.text?("Error 404").should == true
  end
end