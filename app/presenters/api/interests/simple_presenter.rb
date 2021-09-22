class Api::Interests::SimplePresenter < Api::Interests::BasePresenter

  attributes :id, :user_id, :name, :posts_count, :shared, :membership

end
