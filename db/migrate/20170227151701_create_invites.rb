class CreateInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :invites do |t|
      t.integer :user_id, null: false
      t.string :email, null: false
      t.string :status, null: false
      t.timestamps
    end
    add_index :invites, :user_id
  end
end
