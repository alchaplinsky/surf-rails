class Api::NotePresenter < BasePresenter
  include Rails.application.routes.url_helpers

  attributes :title, :url, :text

  def url
    share_url(hashid: object.hashid)
  end

end
