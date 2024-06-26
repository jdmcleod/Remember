class CreateBeRealConnections < ActiveRecord::Migration[7.1]
  def change
    create_table :be_real_connections do |t|
      t.belongs_to :user, null: false, foreign_key: true

      t.integer :status, default: 0
      t.string :session_info

      t.string :bereal_access_token
      t.string :firebase_refresh_token
      t.string :firebase_id_token
      t.string :token_type
      t.datetime :expiration
      t.string :uid
      t.boolean :is_new_user

      t.timestamps
    end
  end
end
