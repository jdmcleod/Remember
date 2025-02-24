class Musing < ApplicationRecord
  include DateScopes

  has_one :entry, as: :journalable, dependent: :destroy, class_name: 'Entry'

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [54, 54]
  end

  validates :name, :date, presence: true

  enum :kind, [
    :generic,
    :book,
    :album,
    :movie,
    :bible_verse,
    :realization,
    :perplexity,
    :resolution,
    :testimony,
  ]

  def kind_humanized
    kind.to_s.humanize
  end
end
