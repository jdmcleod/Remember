class SessionsController < ApplicationController
  skip_before_action :require_authentication!, only: [:create, :index]
  def index
    render layout: 'full_screen'
  end

  def create
    auth = request.env['omniauth.auth']

    user = User.create_with(
      name: auth['info']['email'],
      profile_image_url: auth['info']['image']
    ).find_or_create_by(
      email: auth['info']['name']
    )

    session[:current_user_id] = user.id
    redirect_to current_years_path, notice: "Welcome, #{user.name}"
  end

  def failure
    redirect_to login_url, alert: 'You are unauthorized to view this site. Please contact an administrator to gain access.'
  end

  def destroy
    session[:current_user_id] = nil
    @current_user = nil

    redirect_to sessions_path, notice: 'Signed out successfully.'
  end
end
