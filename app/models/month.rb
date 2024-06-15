class Month < ApplicationRecord
  belongs_to :quarter

  has_one :year, through: :quarter
  has_one :user, through: :year
  has_many :days, dependent: :destroy
end
