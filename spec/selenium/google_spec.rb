require "spec_helper"

describe "google" do

  it "should open the main page" do
    @driver.get("https://www.google.com")
  end
end