class MigrateInterestsToMemberships < ActiveRecord::Migration[5.0]
  def up
    Interest.find_each do |interest|
      InterestMembership.create(user_id: interest.user_id, interest_id: interest.id, role: 'owner')
    end
  end

  def down
    InterestMembership.destroy_all
  end
end
