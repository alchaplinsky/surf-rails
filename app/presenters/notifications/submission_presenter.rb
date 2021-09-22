class Notifications::SubmissionPresenter < Notifications::BasePresenter

  def type
    'submission:created'
  end

  def body
    "Has added a post to &#{@interest.name}"
  end

end
