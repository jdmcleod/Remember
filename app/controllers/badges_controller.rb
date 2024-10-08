class BadgesController < ApplicationController
  def index
    @badges = current_user.badges.order(created_at: :desc)
    render layout: 'modal'
  end

  def new
    @badge = current_user.badges.build
    render layout: 'modal'
  end

  def edit
    @badge = current_user.badges.find(params[:id])
  end

  def create
    @badge = current_user.badges.build(badge_params)

    if @badge.save
      update_view_for_success
    else
      render turbo_stream: turbo_stream.update('modal-body', partial: 'badges/form')
    end
  end

  def update
    @badge = current_user.badges.find(params[:id])

    if @badge.update(badge_params)
      update_view_for_success
    else
      render turbo_stream: turbo_stream.update('modal-body', partial: 'badges/form')
    end
  end

  def destroy
    @badge = current_user.badges.find(params[:id])
    @badge.destroy
    update_view_for_success
  end

  private

  def update_view_for_success
    @badges = current_user.badges.order(created_at: :desc)
    redirect_to badges_path
  end

  def badge_params
    params.require(:badge).permit(:name, :color, :icon_name)
  end
end
