class CreateEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :entries do |t|
      t.string :title
      t.datetime :date
      t.belongs_to :user, foreign_key: true
      t.bigint :journalable_id
      t.string :journalable_type

      t.timestamps
    end
  end
end
