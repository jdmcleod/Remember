class ApplicationController < ActionController::Base
  include Authentication

  protect_from_forgery with: :exception
  helper_method :presenter, :presenter_for
  around_action :set_time_zone, if: :current_user
  attr_reader :presenter
  allow_browser versions: :modern

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
end
