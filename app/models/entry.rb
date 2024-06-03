class Entry < ApplicationRecord
  has_rich_text :content
  belongs_to :user

  belongs_to :journalable, polymorphic: true

  def title
    return journalable.title if journalable.respond_to?(:title)

    super
  end
end
