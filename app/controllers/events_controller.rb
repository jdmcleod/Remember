class EventsController < ApplicationController
  before_action :set_year
  def new
    @event = current_user.events.new
  end

  def index
    @events = current_user.events.in_year(@year).order(:start_date)
    render layout: 'modal'
  end

  def create
    @event = current_user.events.new(event_params)

    if @event.save
      update_view_for_success
    else
      render turbo_stream: turbo_stream.replace('events', partial: 'events/event_form', locals: { event: @event })
    end
  end

  def edit
    @event = current_user.events.find(params[:id])
  end

  def update
    @event = current_user.events.find(params[:id])

    if @event.update(event_params)
      update_view_for_success
    else
      render turbo_stream: turbo_stream.replace('events', partial: 'events/event_form', locals: { event: @event })
    end
  end

  def destroy
    @event = current_user.events.find(params[:id])
    @event.destroy
    respond_to do |format|
      format.turbo_stream { update_view_for_success }
      format.html { redirect_to current_years_path }
    end
  end

  private

  def update_view_for_success
    @events = current_user.events.in_year(@year)
    render turbo_stream: [
      turbo_stream.replace('events', partial: 'events/events', locals: { events: @events }),
      turbo_stream.replace('new-event-button', partial: 'events/new_button'),
    ].join
  end

  def set_year
    @year = current_user.years.find_by(year: params[:year_id])
  end

  def event_params
    params.require(:event).permit(:start_date, :end_date, :name, :color)
  end
end
