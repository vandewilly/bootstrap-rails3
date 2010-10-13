class SessionsController < ApplicationController

  def new
    respond_to do |format|
      format.html {}
    end
  end

  def create
    auth = request.env['omniauth.auth']
    unless @auth = Authentication.find_from_hash(auth)
      # Create a new user or add an auth to existing user, depending on
      # whether there is already a user signed in.
      @auth = Authentication.create_from_hash(auth, current_user)
    end
    # Log the authorizing user in.
    self.current_user = @auth.user
    flash[:success] = 'Signed in successfully.'
    render(:text => "Welcome, #{current_user.id}.")
  end

  def destroy
    current_user = nil
  end

end
