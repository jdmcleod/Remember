class Musing < ApplicationRecord
  self.abstract_class = true
  self.table_name = :musings
  include DateScopes

  has_one :entry, as: :journalable, dependent: :destroy, class_name: 'Entry'

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [54, 54]
  end

  validates :name, :date, presence: true

  # attribute :custom_fields, CustomFields.new(custom_field_keys)
end
