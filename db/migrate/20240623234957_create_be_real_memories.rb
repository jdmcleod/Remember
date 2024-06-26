class CreateBeRealMemories < ActiveRecord::Migration[7.1]
  def change
    create_table :be_real_memories do |t|
      t.belongs_to :day, null: false, foreign_key: true
      t.boolean :late, default: false
      t.string :be_real_id
      t.jsonb :location

      t.timestamps
    end
  end
end
