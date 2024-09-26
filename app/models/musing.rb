class Musing < ApplicationRecord
  belongs_to :day

  has_one :entry, as: :journalable, dependent: :destroy, class_name: 'Entry'

  enum type: [ :book, :movie, :album, :bible_verse, :realization, :perplexity, :resolution, :testimony ]
end