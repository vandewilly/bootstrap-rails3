class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:show]

  def dashboard
  end
end
