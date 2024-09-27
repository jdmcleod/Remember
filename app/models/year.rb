class Year < ApplicationRecord
  belongs_to :user

  has_many :quarters, -> { order(start_date: :asc) }, dependent: :destroy
  has_many :months, through: :quarters
  has_many :days, through: :months

  has_many_attached :image_highlights do |attachable|
    attachable.variant :thumb, resize_to_limit: [52, 52]
  end

  def to_param
    year.to_s
  end

  def events
    user.events.in_range(start_date, end_date)
  end

  def self.current_year
    find_or_create_by(year: Date.current.year)
  end

  def missing_data?
    quarters.none?
  end

  def generate_data
    (start_date..end_date).each do |date|
      quarter = quarters.find_or_create_by(start_date: date.beginning_of_quarter, end_date: date.end_of_quarter)
      month = quarter.months.find_or_create_by(name: date.strftime('%B'), start_date: date.beginning_of_month, end_date: date.end_of_month)
      month.days.find_or_create_by(date: date)
    end
  end

  def start_date
    Date.parse("#{year}-1-1")
  end

  def end_date
    Date.parse("#{year}-12-31")
  end
end
