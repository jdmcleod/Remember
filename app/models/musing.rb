class Musing < ApplicationRecord
  belongs_to :day

  has_one :entry, as: :journalable, dependent: :destroy, class_name: 'Entry'
end