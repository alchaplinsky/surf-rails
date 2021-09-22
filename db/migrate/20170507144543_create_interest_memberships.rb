class CreateInterestMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :interest_memberships do |t|
      t.integer :interest_id, null: false
      t.integer :user_id, null: false
      t.integer :position, null: false, default: 0
      t.string  :role, default: 'member'
      t.timestamps
    end
  end
end
