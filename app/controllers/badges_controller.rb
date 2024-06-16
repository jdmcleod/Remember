class BadgesController < ApplicationController
  def index
    @badges = current_user.badges.order(created_at: :desc)
  end

  def new
    @badge = current_user.badges.build
  end

  def edit
    @badge = Badge.find(params[:id])
  end
end
