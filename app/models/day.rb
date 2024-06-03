class Day < ApplicationRecord
  belongs_to :month

  has_one :daily_entry, as: :journalable, dependent: :destroy

  def number
    date.mday
  end
end
