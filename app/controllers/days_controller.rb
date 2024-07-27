class DaysController < ApplicationController
  def add_badge
    @day = Day.find_by(id: params[:id])
    @day.day_badges.find_or_create_by(badge_id: params[:badge_id])

    render turbo_stream: turbo_stream.replace('day-popup-form', partial: 'entries/day_popup_form')
  end
end
