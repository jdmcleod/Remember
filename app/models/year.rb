class Year < ApplicationRecord
  belongs_to :user
  has_many :quarters, dependent: :destroy

  def self.current_year
    find_or_create_by(year: Date.today.year)
  end

  def missing_data?
    quarters.none?
  end

  def generate_data
    (start_date..end_date).each do |date|
      quarter = quarters.find_or_create_by(start: date.beginning_of_quarter, end: date.end_of_quarter)
      month = quarter.months.find_or_create_by(name: date.strftime('%B'), start: date.beginning_of_month, end: date.end_of_month)
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
