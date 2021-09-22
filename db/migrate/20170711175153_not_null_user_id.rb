class NotNullUserId < ActiveRecord::Migration[5.1]
  def up
    change_column :submissions, :user_id, :integer, null: false
    add_index :submissions, :interest_id
    add_index :submissions, :user_id
  end

  def down
    remove_index :submissions, :user_id
    remove_index :submissions, :interest_id
    change_column :submissions, :user_id, :integer, null: true
  end
end
