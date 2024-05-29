class Day < ApplicationRecord
  belongs_to :month

  def number
    date.mday
  end
end
