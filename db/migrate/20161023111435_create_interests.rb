class CreateInterests < ActiveRecord::Migration[5.0]
  def change
    create_table :interests do |t|
      t.integer :user_id
      t.string  :name
      t.timestamps
    end
  end
end
