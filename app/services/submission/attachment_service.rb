class Submission::AttachmentService

  def initialize(url)
    @url = url
  end

  def attributes
    {
      title: title,
      format: format,
      domain: domain,
      url: url
    }
  end

  protected

  def title
    url.split('/').last
  end

  def format
    title.split('.').last
  end

  def domain
    url.gsub(/https?:\/\//, '').split('/').first
  end

  def url
    @url
  end

end
