class AddCachedBeRealDataToBeRealConnection < ActiveRecord::Migration[7.1]
  def change
    add_column :be_real_connections, :cached_be_real_data, :jsonb, default: {}
  end
end
