class Year < ApplicationRecord
  belongs_to :user

  def self.current_year
    find_or_create_by(year: Date.today.year)
  end
end
