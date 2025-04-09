class AddSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions do |t|
      t.integer :user_id, null: false
      t.string :token, null: false
      t.string :ip_address
      t.string :user_agent
      t.datetime :last_active_at, null: false
      t.timestamps
    end
  end
end
