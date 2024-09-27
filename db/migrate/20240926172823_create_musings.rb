class CreateMusings < ActiveRecord::Migration[7.1]
  def change
    create_table :musings do |t|
      t.string :name
      t.string :description
      t.string :type, default: "generic"
      t.belongs_to :day, null: false, foreign_key: true

      t.timestamps
    end
  end
end
