class AddBadges < ActiveRecord::Migration[7.1]
  def change
    create_table :badges do |t|
      t.string :icon
      t.string :color
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end

    create_table :day_badges do |t|
      t.belongs_to :badge, null: false, foreign_key: true
      t.belongs_to :day, null: false, foreign_key: true
    end
  end
end
