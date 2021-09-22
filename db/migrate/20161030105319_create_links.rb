class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.integer :submission_id
      t.string :title
      t.string :url
      t.string :domain
      t.string :description
      t.string :image
      t.timestamps
    end
  end
end
