class Musing < ApplicationRecord
  include DateScopes

  belongs_to :day

  has_one :entry, as: :journalable, dependent: :destroy, class_name: 'Entry'

  enum type: {
    generic: 'generic',
    book: 'book',
    album: 'album',
    movie: 'movie',
    bible_verse: 'bible_verse',
    realization: 'realization',
    perplexity: 'perplexity',
    resolution: 'resolution',
    testimony: 'testimony',
  }
end
