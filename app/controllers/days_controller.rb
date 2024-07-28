class DaysController < ApplicationController
  def add_badge
    @day = Day.find(params[:id])
    @day.badges << Badge.find(params[:badge_id])

    render turbo_stream: turbo_stream.replace('day-popup-form', partial: 'entries/day_popup_form')
  end

  def remove_badge
    DayBadge.find_by(day_id: params[:id], badge_id: params[:badge_id]).destroy

    render turbo_stream: turbo_stream.replace('day-popup-form', partial: 'entries/day_popup_form')
  end
end
