# frozen_string_literal: true

class DayPresenter < ApplicationPresenter
  include ActionView::Helpers::TagHelper

  alias day presented

  delegate_missing_to :presented

  attr_reader :event_dates

  def set_events(event_dates, events)
    @event_dates = event_dates
    @events = events
  end

  def events
    during_event ? @events.select { _1.contains_date(day.date) } : nil
  end

  def during_event = event_dates&.include?(day.date)
  def primary_event = events&.detect { _1.primary? }
  def secondary_event = events&.detect { _1.secondary? }
  def decorator_event = events&.detect { _1.decorator.present? }
  def date = day.date.strftime("%Y-%-m-%-d")

  def show_primary_trip_handle?
    primary_event.present? && day.date == primary_event.start_date && primary_event.decorator.blank?
  end

  def show_secondary_trip_handle?
    secondary_event.present? && day.date == secondary_event.start_date && secondary_event.decorator.blank?
  end

  def primary_style
    primary_event.present? && decorator_event.blank? ? "background-color: #{primary_event&.color}" : nil
  end

  def secondary_style
    secondary_event.present? && decorator_event.blank? ? "background-color: #{secondary_event&.color}" : nil
  end

  def classes
    class_names('day--current': day.date == Date.today, 'day--future': day.date > Date.today)
  end

  def trip_class(event, secondary = false)
    return unless event.present?

    return 'trip' if event.single_day?

    event_type = secondary ? 'secondary' : 'primary'

    return "trip__#{event_type}--start" if event.start_date == day.date
    return "trip__#{event_type}--end" if event.end_date == day.date
  end

  def secondary_trip_class
    trip_class(secondary_event, true)
  end

  def decorator_class
    class_names('trip__decoration', "trip__decoration--#{decorator_event.decorator}")
  end

  def wrapper_class(event)
    return "day__wrapper #{trip_class(event)}" if event.present? && event.decorator.blank?
    return "day__wrapper day__wrapper--no-entry}" if short_entry.blank?
    'day__wrapper'
  end
end
