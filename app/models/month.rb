class Month < ApplicationRecord
  belongs_to :quarter
  has_many :days, dependent: :destroy
end
