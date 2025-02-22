class Entry < ApplicationRecord
  include PgSearch::Model

  has_rich_text :content, encrypted: true
  belongs_to :user

  belongs_to :journalable, polymorphic: true

  encrypts :title

  scope :in_range, -> (start_date, end_date) do
    where(arel_table[:date].gteq(start_date))
      .where(arel_table[:date].lteq(end_date.end_of_day))
      .order(arel_table[:date])
  end

  before_save do
    self.tsv = tsvectorized_text
  end

  pg_search_scope :search,
    against: [:title],
    using: { tsearch: { dictionary: 'english', tsvector_column: 'tsv' } }

  def title
    return journalable.title if journalable.respond_to?(:title)

    super
  end

  def as_json(options = nil)
    {
      title:,
      date:,
      user_id:,
      journalable_id:,
      journalable_type:,
      created_at:,
      content: content&.body&.to_plain_text
    }
  end

  def empty?
    content.blank?
  end

  private

  def tsvectorized_text
    escaped_text = content.to_plain_text&.gsub("\\", '\&\&')&.gsub("'", "''")
    sql = <<~SQL
      SELECT (
        to_tsvector('english'::regconfig, COALESCE('#{escaped_text}'::text, ''::text))
      )
    SQL
    self.class.connection.execute(sql).values.first.first
  end
end
