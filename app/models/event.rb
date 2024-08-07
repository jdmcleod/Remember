class Event < ApplicationRecord
  belongs_to :user

  scope :in_range, -> (year) { where(arel_table[:start_date].gteq(year.start_date)).where(arel_table[:end_date].lteq(year.end_date)) }

  validate :start_date_not_after_end_date
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  def contains_date?(date)
    start_date <= date && end_date >= date
  end

  def month
    user.months.find_or_create_by(start_date: start_date.beginning_of_month)
  end

  private

  def start_date_not_after_end_date
    return unless start_date && end_date && start_date > end_date

    errors.add(:start_date, 'must be before or equal to end_date')
  end
end
