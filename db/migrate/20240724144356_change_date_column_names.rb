class ChangeDateColumnNames < ActiveRecord::Migration[7.1]
  def change
    rename_column :quarters, :start, :start_date
    rename_column :quarters, :end, :end_date

    rename_column :months, :start, :start_date
    rename_column :months, :end, :end_date
  end
end
