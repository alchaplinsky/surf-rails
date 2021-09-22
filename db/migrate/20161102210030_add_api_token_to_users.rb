class AddApiTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :api_token, :string, limit: 255, null: false
    add_index :users, :api_token, unique: true
  end
end
