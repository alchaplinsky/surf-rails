class CreateUpgrades < ActiveRecord::Migration[5.2]
  def change
    create_table :upgrades do |t|
      t.integer :user_id
      t.string :order_id
      t.string :payer_id
      t.string :email
      t.string :name
      t.string :phone
      t.string :country
      t.string :status
      t.timestamps
    end
  end
end
