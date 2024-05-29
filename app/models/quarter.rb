class Quarter < ApplicationRecord
  belongs_to :year
  has_many :months, dependent: :destroy
end
