class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  before_action :set_year
  def new
    @event = current_user.events.new
  end

  def index
    find_events
    render layout: 'modal'
  end

  def show
    @entries = current_user.entries.in_range(@event.start_date, @event.end_date)
    render layout: 'modal'
  end

  def create
    @event = current_user.events.new(event_attrs)

    if @event.save
      update_view_for_success
    else
      render turbo_stream: turbo_stream.update('modal-body', partial: 'events/form')
    end
  end

  def edit
  end

  def update
    if @event.update(event_attrs)
      update_view_for_success
    else
      render turbo_stream: turbo_stream.update('modal-body', partial: 'events/form')
    end
  end

  def destroy
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
      turbo_stream.update('modal-body', partial: 'events/events'),
      turbo_stream.update('modal-header-actions', partial: 'events/new_button'),
      turbo_stream.replace('modal-footer-actions', inline: '<div id="modal-footer-actions"/>')
    ].join
  end

  def set_year
    @year = current_user.years.find_by(year: params[:year_id])
  end

  def set_event
    @event = current_user.events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:start_date, :end_date, :name, :color, :icon_name, :decorator, :single_day, :secondary)
  end

  def event_attrs
    attrs = event_params.to_h
    attrs[:end_date] = nil if Boolean(attrs[:single_day])
    attrs[:decorator] = nil if attrs[:end_date].present?
    attrs
  end

  def find_events
    @events = current_user.events.in_range(@year.start_date, @year.end_date).order(:start_date)
  end
end
