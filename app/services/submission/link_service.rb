class Submission::LinkService

  DEFAULT_LINK_IMAGE = 'http://placehold.it/50x50'
  DEFAULT_LINK_DESCRIPTION = 'No content'

  attr_reader :attachment_type

  def initialize(url, page)
    @url = url
    @page = page
  end

  def attributes
    link_params = Hash.new
    link_params[:title] = @page.best_title.blank? ? @url : @page.best_title
    link_params[:description] = @page.description.blank? ? DEFAULT_LINK_DESCRIPTION : @page.description
    link_params[:image] = @page.images.best.blank? ? DEFAULT_LINK_IMAGE : @page.images.best
    link_params[:domain] = @page.host
    link_params[:url] = @url
    link_params
  end

end
