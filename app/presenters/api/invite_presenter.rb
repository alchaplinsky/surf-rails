class Api::InvitePresenter < BasePresenter
  attributes :email, :status, :created_at

  def created_at
    object.created_at.strftime('%d %b, %Y')
  end
end
