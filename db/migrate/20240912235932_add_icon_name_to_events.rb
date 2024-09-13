class AddIconNameToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :icon_name, :string
  end
end
