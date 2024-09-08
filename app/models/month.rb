class Month < ApplicationRecord
  belongs_to :quarter

  has_one :year, through: :quarter
  has_one :user, through: :year
  has_many :days, dependent: :destroy

  has_one :entry, as: :journalable, dependent: :destroy, class_name: 'Entry'

  def number
    start_date.month
  end

  def find_entry
    return entry if entry.present?

    create_entry(user: year.user, date: start_date)
  end
end
