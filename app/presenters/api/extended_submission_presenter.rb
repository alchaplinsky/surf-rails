class Api::ExtendedSubmissionPresenter < Api::SubmissionPresenter

  attributes :id, :user_id, :interest_id, :text, :url, :link, :note, :image, :attachment, :date, :tags, :owner

  def owner
    {
      name: object.user.full_name,
      avatar: object.user.avatar.url
    }
  end

end
