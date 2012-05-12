require "selenium_spec_helper"

describe "wikipedia" do

  it "should have a featured article" do
    selenium.get("http://en.wikipedia.org")
    selenium.text?("Today's featured article").should be_true
    selenium.text?("was named \"box office poison\"").should be_true
  end
end