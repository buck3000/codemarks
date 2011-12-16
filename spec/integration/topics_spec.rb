require 'spec_helper'

describe "topics" do
  describe "while signed in" do
    before do
      simulate_signed_in
    end

    it "lets you save a new topics" do
      visit new_topic_path
      page.fill_in :title, with: "Incoming Email Parser"
      page.click_button "Create Topic"
      page.should have_content "Topic created"
    end

    it "has an index" #do
    #  3.times { Fabricate(:topic) }
    #  count = Topic.count
    #  visit topics_path
    #  page.should have_selector("li.topic", :count => 3)
    #end
  end

  describe "as a visitor" do
    it "has an index" do
      3.times { Fabricate(:topic) }
      count = Topic.count
      visit topics_path
      page.should have_selector("li.topic", :count => 3)
    end
  end
end