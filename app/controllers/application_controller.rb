class ApplicationController < ActionController::Base
  helper_method :current_user

  before_action :authenticate_oauth

  protected

  def authenticate_oauth
    return if current_user.present?

    redirect_to sessions_path
  end

  def current_user
    @current_user ||= User.find_by(id: session[:current_user_id]) if session[:current_user_id]
  end
end
