require "spec_helper"

describe "wikipedia" do

  it "should open the main page" do
    @driver.get("http://en.wikipedia.org")
    debugger
    true
  end
end