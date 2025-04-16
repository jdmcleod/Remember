class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ create index]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { render_rejection :too_many_requests }

  def index
    return redirect_to current_years_path if current_user
    render layout: 'full_screen'
  end

  def create
    auth = request.env['omniauth.auth']
    name = auth['info']['name']
    profile_image_url = auth['info']['image']
    email = auth['info']['email']

    if user = User.create_with(name:, profile_image_url:).find_or_create_by(email:)
      start_new_session_for user
      session[:current_user_id] = user.id
      redirect_to current_years_path, notice: "Welcome, #{user.name}"
    else
      render_rejection :unauthorized
    end
  end

  def failure
    redirect_to login_url, alert: 'You are unauthorized to view this site. Please contact an administrator to gain access.'
  end

  def destroy
    reset_authentication
    redirect_to sessions_path, notice: 'Signed out successfully.'
  end

  private

  def render_rejection(status)
    flash[:alert] = "Too many requests or unauthorized."
    render :new, status: status
  end
end
