class EntriesController < ApplicationController
  def day_popup_form
    date = Date.parse(params[:date])
    day = current_user.days.find_by(date: date)
    @entry = day.find_short_entry
    @memories = day.be_real_memories
  end

  def update
    @entry = Entry.find_by(id: params[:id])
    @entry.update(entry_params)
    @memories = @entry.user.days.find_by(date: @entry.date).be_real_memories

    render turbo_stream: turbo_stream.replace('day-popup-form', partial: 'entries/day_popup_form')
  end

  private

  def entry_params
    params.require(:entry).permit(:content)
  end
end
