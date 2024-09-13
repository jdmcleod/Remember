class Year < ApplicationRecord
  belongs_to :user

  has_many :quarters, -> { order(created_at: :asc) }, dependent: :destroy
  has_many :months, through: :quarters
  has_many :days, through: :months

  def to_param
    year.to_s
  end

  def self.current_year
    find_or_create_by(year: Date.today.year)
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
