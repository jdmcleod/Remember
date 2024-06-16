class User < ApplicationRecord
  has_many :years, dependent: :destroy
  has_many :quarters, through: :years
  has_many :months, through: :quarters
  has_many :days, through: :months

  has_many :badges, dependent: :destroy

  after_create :create_default_badges!

  def create_default_badges!
    badges.insert_all!(Badge.default_badges)
  end
end
