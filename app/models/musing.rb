class Musing < ApplicationRecord
  belongs_to :day
  belongs_to :month, through: :day
  belongs_to :quarter, through: :month
  belongs_to :year, through: :quarter
  belongs_to :user, through: :year

  has_one :entry, as: :journalable, dependent: :destroy, class_name: 'Entry'
end