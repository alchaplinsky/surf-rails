class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.integer :interest_id
      t.text    :text
      t.timestamps
    end
  end
end
