class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.integer :submission_id
      t.string :title
      t.string :url
      t.string :domain
      t.timestamps
    end
  end
end
