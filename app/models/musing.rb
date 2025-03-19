class Musing < ApplicationRecord
  self.abstract_class = true
  self.table_name = :musings
  include DateScopes

  belongs_to :user

  has_one :entry, as: :journalable, dependent: :destroy, class_name: 'Entry'

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [54, 54]
  end

  validates :name, :date, presence: true

  def find_entry
    return entry if entry.present?

    build_entry(user: user, date: date)
  end
end
