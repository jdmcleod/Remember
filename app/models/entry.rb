class Entry < ApplicationRecord
  has_rich_text :content

  belongs_to :journalable, polymorphic: true
end
