class ChangeMusingTypeToKind < ActiveRecord::Migration[8.0]
  def change
    rename_column :musings, :type, :kind
    add_column :musings, :user_id, :bigint
    add_foreign_key :musings, :users

    remove_column :musings, :day_id, :bigint
    add_column :musings, :date, :datetime
    remove_column :musings, :description, :string
  end
end
