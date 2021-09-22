class AddUserIdToSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :submissions, :user_id, :integer
  end
end
