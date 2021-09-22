class Api::Interests::ExtendedPresenter < Api::Interests::BasePresenter

  attributes :id, :user_id, :name, :posts_count, :shared, :membership, :tags

  def tags
    object.tags.group('name').order('count_name desc').count('name').map{|k,v| k}
  end

end
