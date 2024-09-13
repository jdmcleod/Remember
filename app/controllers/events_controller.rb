class EventsController < ApplicationController
  before_action :set_year
  def new
    @event = current_user.events.new
  end

  def index
    @events = current_user.events.in_range(@year.start_date, @year.end_date).order(:start_date)
    render layout: 'modal'
  end

  def show
    @event = current_user.events.find(params[:id])
    @entries = current_user.entries.in_range(@event.start_date, @event.end_date)
    render layout: 'modal'
  end

  def create
    @event = current_user.events.new(event_params)

    if @event.save
      update_view_for_success
    else
      render turbo_stream: turbo_stream.update('modal-body', partial: 'events/form')
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
      render turbo_stream: turbo_stream.update('modal-body', partial: 'events/form')
    end
  end

  def destroy
    @event = current_user.events.find(params[:id])
    @event.destroy
    update_view_for_success
  end

  private

  def update_view_for_success
    @events = current_user.events.in_range(@year.start_date, @year.end_date)

    redirect_to year_events_path
  end

  def set_year
    @year = current_user.years.find_by(year: params[:year_id])
  end

  def event_params
    params.require(:event).permit(:start_date, :end_date, :name, :color, :icon_name, :decorator)
  end
end
