class AddDateTables < ActiveRecord::Migration[7.1]
  def change
    create_table(:years) do |t|
      t.belongs_to :user
      t.string :year

      t.timestamps
    end

    create_table(:quarters) do |t|
      t.belongs_to :year
      t.date :start
      t.date :end

      t.timestamps
    end

    create_table(:months) do |t|
      t.belongs_to :quarter
      t.string :name
      t.date :start
      t.date :end

      t.timestamps
    end

    create_table(:days) do |t|
      t.belongs_to :month
      t.date :date

      t.timestamps
    end
  end
end
