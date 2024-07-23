class User < ApplicationRecord
  has_many :years, dependent: :destroy
  has_many :quarters, through: :years
  has_many :months, through: :quarters
  has_many :days, through: :months

  has_many :badges, dependent: :destroy

  has_many :entries, dependent: :destroy

  has_one :be_real_connection, dependent: :destroy

  def be_real_connected?
    be_real_connection&.connected?
  end
end
