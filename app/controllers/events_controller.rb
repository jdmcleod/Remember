class EventsController < ApplicationController
  before_action :set_year
  def new
    @event = current_user.events.new
  end

  def index
    find_events
    render layout: 'modal'
  end

  def show
    @event = current_user.events.find(params[:id])
    @entries = current_user.entries.in_range(@event.start_date, @event.end_date)
    render layout: 'modal'
  end

  def create
    attrs = event_params.to_h
    @event = current_user.events.new(attrs)

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
    find_events
    @event_dates = @events.flat_map(&:range).uniq
    months = current_user.months.contains_date(@event.start_date).contains_date(@event.end_date)
    render turbo_stream: [
      months.map do |month|
        turbo_stream.replace("month-#{month.number}", partial: 'months/month', locals: { month: })
      end,
      turbo_stream.update('modal-body', partial: 'events/events')
    ].join
  end

  def set_year
    @year = current_user.years.find_by(year: params[:year_id])
  end

  def event_params
    params.require(:event).permit(:start_date, :end_date, :name, :color, :icon_name, :decorator, :single_day)
  end

  def find_events
    @events = current_user.events.in_range(@year.start_date, @year.end_date).order(:start_date)
  end
end
