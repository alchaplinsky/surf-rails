require 'uri'

class Submission::CreationService < Submission::BaseService

  def initialize(interest, params)
    @interest = interest
    @params = params
  end

  def create
    parse_tags_from_text
    parse_urls_from_text
    clear_text
    build_submission
  end

  private

  def parse_tags_from_text
    @tags = HashtagsService.parse_tags params[:text]
  end

  def parse_urls_from_text
    @urls = URI.extract(params[:text], /http|ftp|https/)
  end

  def build_submission
    @submission = @interest.submissions.build params
    @submission.tag_list = @tags
    if @urls.present?
      @submission.send("#{relation_service.type}_attributes=", relation_service.attributes)
    end
    @submission.save
  end

  def relation_service
    @service ||= Submission::RelationService.new @urls.first, params
  end

end
