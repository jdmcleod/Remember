class EventsController < ApplicationController
  before_action :set_year
  def new
    @event = current_user.events.new
  end

  def index
    @events = current_user.events.in_year(@year)
    render layout: 'modal'
  end

  def create
    @event = current_user.events.new(event_params)

    if @event.save
      @events = current_user.events.in_year(@year)
      render turbo_stream: turbo_stream.replace('events', partial: 'events/events', locals: { events: @events })
    else
      render turbo_stream: turbo_stream.replace('events', partial: 'events/event_form', locals: { event: @event })
    end
  end

  # def update
  #   @entry = Entry.find_by(id: params[:id])
  #   @entry.update(entry_params)
  #   @memories = @entry.journalable.be_real_memories
  #
  #   render turbo_stream: turbo_stream.replace('day-popup-form', partial: 'entries/day_popup_form')
  # end

  private

  def set_year
    @year = current_user.years.find_by(year: params[:year_id])
  end

  def event_params
    params.require(:event).permit(:start_date, :end_date, :name, :color)
  end
end
