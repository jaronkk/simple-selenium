require "selenium_spec_helper"

describe "google" do

  it "should open the main page" do
    selenium.get("https://www.google.com")
    selenium.title.should == "Google"
    selenium.text?("Google Search").should be_true
  end

  it "should open /foo and find a 404" do
    selenium.get("http://www.google.com/foo")
    selenium.title.should =~ /Error 404/
    selenium.text?("Google Search").should be_false
    selenium.text?("not found on this server").should be_true
  end
end