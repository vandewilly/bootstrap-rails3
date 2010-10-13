Given /^I am not authenticated$/ do
  visit('/sessions/destroy') # ensure that at least
end

Given /^I have one\s+user "([^\"]*)" with access_token "([^\"]*)"$/ do |user_id, access_token|
  @user = Factory.build(:user, :id => user_id, :access_token => access_token)
end

# Session
Given /^I am signed in$/ do
  visit path_to('the signin page')
  click_link('Facebook')
  if defined?(Spec::Rails::Matchers)
    page.should have_content('Signed in successfully')
  else
    assert page.has_content?('Signed in successfully')
  end
end
