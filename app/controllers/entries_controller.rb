class EntriesController < ApplicationController
  def day_popup_form
    date = Date.parse(params[:date])
    day = current_user.days.find_by(date: date)
    @entry = day.find_short_entry
  end

  def create
  end
end
