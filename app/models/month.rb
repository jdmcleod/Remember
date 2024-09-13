class Month < ApplicationRecord
  belongs_to :quarter

  has_one :year, through: :quarter
  has_one :user, through: :year
  has_many :days, -> { order(date: :asc) }, dependent: :destroy

  has_one :entry, as: :journalable, dependent: :destroy, class_name: 'Entry'

  scope :contains_date, -> (date) { where(arel_table[:start_date].lteq(date)).where(arel_table[:end_date].gteq(date)) }

  def number
    start_date.month
  end

  def find_entry
    return entry if entry.present?

    create_entry(user: year.user, date: start_date)
  end
end
