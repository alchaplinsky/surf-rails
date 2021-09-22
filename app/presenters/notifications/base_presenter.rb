class Notifications::BasePresenter

  def initialize(object, interest, actor, action)
    @object = object
    @interest = interest
    @actor = actor
    @action = action
  end

  def as_json
    {
      type: type,
      title: title,
      body: body,
      interest_id: @interest.id
    }
  end

  def title
    @actor.full_name
  end

end
