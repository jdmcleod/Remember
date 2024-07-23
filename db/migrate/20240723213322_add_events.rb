class AddEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.belongs_to :user, index: true
      t.string :name
      t.date :start_date
      t.date :end_date
      t.string :color
      t.string :decorator

      t.timestamps
    end
  end
end
