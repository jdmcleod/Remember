class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :presenter, :presenter_for

  before_action :require_authentication!
  around_action :set_time_zone, if: :current_user

  attr_reader :presenter

  protected

  def present(resource)
    @presenter = ApplicationPresenter.presenter_for(resource)
  end

  def presenter_for(resource)
    ApplicationPresenter.presenter_for(resource)
  end

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def require_authentication!
    return if current_user.present?

    redirect_to sessions_path
  end

  def current_user
    @current_user ||= User.find_by(id: session[:current_user_id]) if session[:current_user_id]
  end
end
