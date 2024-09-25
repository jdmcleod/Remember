class EntriesController < ApplicationController
  def day_popup_form
    date = Date.parse(params[:date])
    @day = current_user.days.find_by(date: date)
    @entry = @day.find_short_entry
    @memories = @day.be_real_memories
    @image = @day.image
    set_badges
  end

  def update
    @entry = Entry.find_by(id: params[:id])
    @entry.update(entry_params)
    @day = @entry.journalable
    @memories = @day.be_real_memories
    @image = @day.image
    set_badges

    month = @entry.journalable.month
    @events = current_user.events.in_range(month.start_date, month.end_date)
    @event_dates = @events.flat_map(&:range).uniq
    render turbo_stream: [
      turbo_stream.replace('day-popup-form', partial: 'entries/day_popup_form'),
      turbo_stream.replace("month-#{month.number}", partial: 'months/month', locals: { month: @entry.journalable.month }),
    ].join
  end

  def search
    @search_term = params[:q]
    @entries = current_user.entries.order(:date).includes(journalable: [{ be_real_memories: [{ primary_attachment: :blob, secondary_attachment: :blob }] }])

    if search_date
      @entries = @entries.where(date: search_date)
    elsif params[:year_id].present?
      @year = Year.find(params[:year_id])
      @entries = @entries.in_range(@year.start_date, @year.end_date).search(@search_term)
    else
      @entries = @entries.search(@search_term)
    end
    render layout: 'modal', locals: { modal_class: 'modal--full' }
  end

  private

  def search_date
    begin
      @search_date ||= Date.parse(@search_term)
    rescue ArgumentError
    end
  end

  def set_badges
    @day_badges = @day.badges
    @addable_badges = current_user.badges - @day_badges
    @recommended_badges = @day_badges.count >= 7 ? [] : @addable_badges.first(7 - @day_badges.count)
  end

  def entry_params
    params.require(:entry).permit(:content)
  end
end
