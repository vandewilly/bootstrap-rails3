require 'spec_helper'

describe ApplicationHelper do

  describe "#me?" do
    context "when I am the current user" do
      it "should be true" do
        user = mock(:user)
        helper.stub(:current_user).and_return(user)
        helper.send(:me?, user).should be_true
      end
    end

    context "when I am the not current user" do
      it "should be false" do
        user = mock(:user)
        helper.stub(:current_user).and_return(nil)
        helper.send(:me?, user).should be_false
      end
    end
  end

end
