class DaysController < ApplicationController
  def add_badge
    @day = Day.find(params[:id])
    @day.badges << Badge.find(params[:badge_id])

    @day_badges = @day.badges
    @addable_badges = current_user.badges - @day_badges
    @recommended_badges = @day_badges.count >= 3 ? [] : @addable_badges.first(3 - @day_badges.count)
    @entry = @day.find_short_entry
    @memories = @day.be_real_memories

    render turbo_stream: turbo_stream.replace('day-popup-form', partial: 'entries/day_popup_form')
  end

  def remove_badge
    @day = Day.find(params[:id])
    DayBadge.find_by(day_id: @day.id, badge_id: params[:badge_id]).destroy

    @day_badges = @day.badges
    @addable_badges = current_user.badges - @day_badges
    @recommended_badges = @day_badges.count >= 3 ? [] : @addable_badges.first(3 - @day_badges.count)
    @entry = @day.find_short_entry
    @memories = @day.be_real_memories

    render turbo_stream: turbo_stream.replace('day-popup-form', partial: 'entries/day_popup_form')
  end
end
