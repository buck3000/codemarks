require 'spec_helper'

describe "User Profile Page" do
  context "shows user info" do
    before do
      simulate_signed_in
      visit profile_path
    end

    it "lands you on the user profile page" do
      current_path.should == profile_path
    end

    it "has my name" do
      page.should have_content(@user.name)
    end

    it "has my email" do
      page.should have_content(@user.email)
    end

    it "has my nickname" do
      page.should have_content(@user.nickname)
    end

    it "has my location" do
      page.should have_content(@user.location)
    end

    it "has my description" do
      page.should have_content(@user.description)
    end
  end

  context "lets you update your info" do
    before do
      simulate_signed_in
      visit profile_path
      page.click_link "Edit"
    end

    it "asks you for your email address" do
      page.should have_field("user_email")
    end

    it "saves your email address" do
      page.fill_in "user_email", :with => "test@example.com"
      page.click_button "Save"
      User.find(@user.id).email.should == "test@example.com"
      page.should have_content "test@example.com"
    end

    it "displays the authentication's value if it's present" do
      page.should have_field("user_location", with: @user.get(:location))
      page.should have_field("user_description", with: @user.get(:description))
      page.should have_field("user_email", with: @user.get(:email))
      page.should have_field("user_nickname", with: @user.get(:nickname))
    end
  end
end
