class AddIconNameToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :icon_name, :string
    add_column :events, :single_day, :boolean, default: false
  end
end
