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
    @memories = @entry.journalable.be_real_memories

    month = @entry.journalable.month
    @events = current_user.events.in_range(month)
    render turbo_stream: [
      turbo_stream.replace('day-popup-form', partial: 'entries/day_popup_form'),
      turbo_stream.replace("month-#{month.number}", partial: 'years/month', locals: { month: @entry.journalable.month }),
    ].join
  end

  def search
    @search_term = params[:q]
    @entries = current_user.entries.search(@search_term)
    render layout: 'modal'
  end

  private

  def entry_params
    params.require(:entry).permit(:content)
  end
end
