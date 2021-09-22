class Submission::BaseService

  attr_reader :submission, :params, :errors, :api_version

  private

  def clear_text
    remove_empty_tags_from_text
  end

  def remove_empty_tags_from_text
    params[:text].gsub!(/\A<p><br><\/p>\s*/, '')
  end
end
