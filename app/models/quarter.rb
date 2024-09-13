class Quarter < ApplicationRecord
  belongs_to :year

  has_one :user, through: :year
  has_many :months, -> { order(start_date: :asc) }, dependent: :destroy
  has_many :days, through: :months
end
