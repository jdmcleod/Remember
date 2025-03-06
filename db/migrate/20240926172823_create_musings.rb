class CreateMusings < ActiveRecord::Migration[7.1]
  def change
    create_table :musings do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name
      t.string :type
      t.datetime :date
      t.jsonb :custom_fields

      t.timestamps
    end
  end
end
