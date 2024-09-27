class YearHighlight < ApplicationRecord
  belongs_to :year
  has_one :user, through: :year

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [52, 52]
  end
end
