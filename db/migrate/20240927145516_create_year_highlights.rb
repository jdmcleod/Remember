class CreateYearHighlights < ActiveRecord::Migration[7.1]
  def change
    create_table :year_highlights do |t|
      t.integer :position
      t.date :date
      t.belongs_to :year, foreign_key: true, null: false

      t.timestamps
    end

    Year.find_each { |year| year.create_highlights! }
  end
end

class Year < ApplicationRecord
  has_many :highlights, class_name: 'YearHighlight', dependent: :destroy

  def create_highlights!
    6.times { |i| highlights.find_or_create_by(position: i + 1) }
  end
end

class YearHighlight < ApplicationRecord
  belongs_to :year
end
