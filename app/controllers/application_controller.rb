class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :presenter, :presenter_for

  before_action :require_authentication!

  attr_reader :presenter

  protected

  def present(resource)
    @presenter = ApplicationPresenter.presenter_for(resource)
  end

  def presenter_for(resource)
    ApplicationPresenter.presenter_for(resource)
  end

  def require_authentication!
    return if current_user.present?

    redirect_to sessions_path
  end

  def current_user
    @current_user ||= User.find_by(id: session[:current_user_id]) if session[:current_user_id]
  end
end
