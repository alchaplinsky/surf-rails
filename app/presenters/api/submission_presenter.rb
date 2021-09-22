class Api::SubmissionPresenter < BasePresenter
  include Rails.application.routes.url_helpers

  attributes :id, :user_id, :interest_id, :title, :text, :url, :link, :note, :image, :attachment, :date, :tags

  def text
    case @@version
    when 1.0
      clear_text object.text
    else
      object.text
    end
  end

  def url
    if object.link.present?
      object.link.url
    elsif object.image.present?
      object.image.url
    elsif object.attachment.present?
      object.attachment.url
    else
      share_url(hashid: object.hashid)
    end
  end

  def link
    Api::LinkPresenter.new object.link
  end

  def note
    case @@version
    when 1.0
      {
        title: object.title,
        text: object.text,
        url: share_url(hashid: object.hashid)
      }
    else
      return nil
    end
  end

  def image
    Api::ImagePresenter.new object.image
  end

  def attachment
    Api::AttachmentPresenter.new object.attachment
  end

  def tags
    Api::TagPresenter.map object.tags
  end

  def date
    object.created_at.strftime('%b %d, %Y %H:%M %p')
  end

  private

  def clear_text(text)
    without_urls(HashtagsService.without_tags(text))
  end

  def without_urls(text)
    urls = URI.extract(text)
    text.gsub!(urls.first, '') if urls.size == 1
    text.strip
  end

end
