class BackfillSubscriptionsWithUsers < ActiveRecord::Migration[5.1]
  def change
    Submission.preload(interest: :user).where(user_id: nil).find_in_batches do |batch|
      batch.each do |submission|
        submission.update_column :user_id, submission.interest.user.id
      end
    end
  end
end
