require 'spec_helper'

describe "users/dashboard" do
  let(:user) { stub_model(User, name: "Bob Smith", email: "bob@test.com", uid: "12345") }

  it "displays the user information" do
    view.stub(:current_user).and_return(user)
    render
    rendered.should have_content("Bob Smith")
    rendered.should have_content("bob@test.com")
    rendered.should have_content("12345")
  end
end
