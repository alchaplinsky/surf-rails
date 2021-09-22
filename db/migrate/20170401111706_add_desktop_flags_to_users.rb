class AddDesktopFlagsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :app_connected_at, :datetime
  end
end
