class Event < ApplicationRecord
  belongs_to :user

  scope :in_range, -> (query_start_date, query_end_date) { where(arel_table[:start_date].gteq(query_start_date)).where(arel_table[:start_date].lteq(query_end_date)) }
  scope :contains_date, -> (date) { where(arel_table[:start_date].lteq(date)).where(arel_table[:end_date].gteq(date)) }

  validate :start_date_not_after_end_date
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true, if: :multiday?

  enum decorator: {
    celebration: 'celebration'
  }.freeze

  def contains_date?(date)
    start_date <= date && end_date >= date
  end

  def multiday?
    !single_day
  end

  def end_date
    super || start_date
  end

  def range
    (start_date..end_date).to_a
  end

  def year
    user.years.detect { |year| year.year.to_i == start_date.year }
  end

  def month
    user.months.find_or_create_by(start_date: start_date.beginning_of_month)
  end

  def date_range_string
    return start_date.strftime("%B %d, %Y") if single_day?

    "#{start_date.strftime("%B %d, %Y")} - #{end_date.strftime("%B %d, %Y")}"
  end

  def icon_name
    super || 'plane'
  end

  def contains_date(date)
    if end_date.blank?
      return date.beginning_of_day == start_date.beginning_of_day
    end
    start_date <= date && end_date >= date
  end

  def single_day?
    super || (start_date.present? && end_date == start_date)
  end

  private

  def start_date_not_after_end_date
    return unless start_date && end_date && start_date > end_date

    errors.add(:start_date, 'must be before or equal to end_date')
  end
end
