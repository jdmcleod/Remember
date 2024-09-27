class CreateYearImages < ActiveRecord::Migration[7.1]
  def change
    create_table :year_images do |t|
      t.integer :position
      t.belongs_to :year, foreign_key: true, null: false

      t.timestamps
    end
  end
end
