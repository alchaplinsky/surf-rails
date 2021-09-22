class Submission::UpdatingService < Submission::BaseService

  def initialize(submission, params, api_version)
    @submission = submission
    @params = params
    @api_version = api_version
  end

  def update
    if api_version == 1.1
      clear_text
      update_new
    else
      update_old
    end
  end

  private

  def update_old
    update_tags
    if params[:note_attributes].present?
      submission.update_attributes(text: params[:note_attributes][:text])
      return true
    end
    if params[:text].present?
      submission.update_attributes(text: params[:text])
      return true
    end
    if submission.link.present?
      update_relation(:link)
    elsif submission.image.present?
      update_relation(:image)
    elsif submission.attachment.present?
      update_relation(:attachment)
    end
  end

  def update_new
    submission.tag_list = HashtagsService.parse_tags(params[:text])
    submission.assign_attributes(text: params[:text])
    submission.save
  end

  def update_tags
    if params[:tag_list]
      submission.tag_list = HashtagsService.parse_tags(params[:tag_list])
    end
  end

  def update_relation(type)
    unless submission.send(type).update_attributes params[:"#{type}_attributes"]
      @errors = submission.send(type).errors.messages
      return false
    end
    return true
  end

end
