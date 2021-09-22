class Submission::ImageService

  def initialize(url, page = nil)
    @url = url
    @page = page
  end

  def attributes
    {
      title: title,
      domain: domain,
      url: url
    }
  end

  protected

  def title
    url.split('/').last
  end

  def domain
    url.gsub(/https?:\/\//, '').split('/').first
  end

  def url
    @url
  end

end
