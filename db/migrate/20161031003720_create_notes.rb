class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.integer :submission_id
      t.string :title
      t.text :text
      t.timestamps
    end
  end
end
