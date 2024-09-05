class Day < ApplicationRecord
  belongs_to :month

  has_one :quarter, through: :month
  has_one :year, through: :quarter
  has_one :user, through: :year

  has_one :short_entry, as: :journalable, dependent: :destroy, class_name: 'Entry'

  has_many :day_badges, dependent: :destroy
  has_many :badges, through: :day_badges
  has_many :be_real_memories

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [50, 50]
  end

  def self.on(date)
    find_by(date:)
  end

  def number
    date.mday
  end

  def find_short_entry
    return short_entry if short_entry.present?

    create_short_entry(user: month.quarter.year.user, date: date)
  end

  def trip_class(event)
    return unless event.present?

    return 'day--event' if event.single_day?

    return 'day--trip-start' if event.start_date == date
    return 'day--trip-end' if event.end_date == date
  end

  def wrapper_class(event)
    return "day__wrapper #{trip_class(event)}" if event.present? && event.decorator.blank?
    return "day__wrapper day__wrapper--no-entry}" if short_entry.blank?
    'day__wrapper'
  end

  def during_event?(event)
    event.start_date <= date && event.end_date >= date
  end

  def title
    suffix = if (11..13).include?(date.day % 100)
      "#{date.day}th"
    else
      case date.day % 10
      when 1 then "#{date.day}st"
      when 2 then "#{date.day}nd"
      when 3 then "#{date.day}rd"
      else "#{date.day}th"
      end
    end

    date.strftime("%B #{suffix}")
  end
end
