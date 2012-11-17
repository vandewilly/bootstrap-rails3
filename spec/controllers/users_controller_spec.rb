require 'spec_helper'

describe UsersController do

  describe "GET 'dashboard'" do
    it "returns http success" do
      controller.stub(:authenticate_user!).and_return(true)
      get 'dashboard'
      response.should be_success
    end
  end
end
