class DaysController < ApplicationController
  def add_badge
    @day = Day.find(params[:id])
    @day.badges << Badge.find(params[:badge_id])

    set_badges
  end

  def remove_badge
    @day = Day.find(params[:id])
    DayBadge.find_by(day_id: @day.id, badge_id: params[:badge_id]).destroy

    set_badges
  end

  def update
    @day = Day.find(params[:id])
    if @day.update(day_params)
      redirect_to day_popup_form_entries_path(@day.date)
    end
  end

  private

  def set_badges
    @day_badges = @day.badges
    @addable_badges = current_user.badges - @day_badges
    @recommended_badges = @day_badges.count >= 6 ? [] : @addable_badges.first(6  - @day_badges.count)
  end

  def day_params
    params.require(:day).permit(:image)
  end
end
