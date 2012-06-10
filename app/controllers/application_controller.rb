class ApplicationController < ActionController::Base

  helper_method :current_user, :user_signed_in?, :admin?

  protect_from_forgery

  protected

  def verify_admin
    if user_signed_in?
      redirect_to(user_url(current_user)) unless admin?
    else
      redirect_to(root_url)
    end
  end

  def authenticate_user!
    if !current_user
      redirect_to(sign_in_path)
      false
    end
  end

  def verify_signed_in_user
    if !user_signed_in?
      if params['format'] == 'js'
        render(:text => "auth-required", :status => 403)
      else
        redirect_to(root_url)
      end
    end
  end

  def user_signed_in?
    !!current_user
  end

  def admin?
    !current_user.blank? && current_user.admin?
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
