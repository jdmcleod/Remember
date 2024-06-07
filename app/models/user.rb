class User < ApplicationRecord
  has_many :years
  has_many :quarters, through: :years
  has_many :months, through: :quarters
  has_many :days, through: :months
end
