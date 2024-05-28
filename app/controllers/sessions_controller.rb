class SessionsController < ApplicationController
  skip_before_action :authenticate_oauth, only: [:create, :index]
  def index
    render layout: 'full_screen'
  end

  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_create_by(email: auth['info']['email'])

    session[:current_user_id] = user.id
    redirect_to root_url, notice: "Welcome, #{user.name}"
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
