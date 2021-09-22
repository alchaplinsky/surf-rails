class Submission::RelationService

  attr_reader :type

  WHITELIST_EXTENSIONS = %w(.html .htm .shtml .phtml .php .php3 .php4 .asp .aspx .axd .asx .asmx .ashx .cfm .jsp .yaws .jspx .jpg .png .gif .webp .bmp)

  def initialize(url, params)
    @url = url
    @params = params
    process
  end

  def attributes
    case type
    when 'skip'
      return false
    when 'attachment'
      service = Submission::AttachmentService.new(@url)
    else
      service = "Submission::#{type.capitalize}Service".constantize.new(@url, @page)
    end
    service.attributes
  end

  protected

  def process
    if is_parsable_url? and @page = parse_url
      case @page.content_type
      when 'text/html'
        @type = 'link'
      when 'image/jpeg', 'image/png', 'image/gif'
        @type = 'image'
      when 'unknonw'
        @type = 'skip'
      else
        @type = 'attachment'
      end
    else
      @type = 'attachment'
    end
  end

  def is_parsable_url?
    extension = File.extname(URI.parse(@url).path)
    extension.blank? or WHITELIST_EXTENSIONS.include?(extension)
  end

  def parse_url
    MetaInspector.new @url, allow_non_html_content: true
  rescue MetaInspector::RequestError, MetaInspector::ParserError, MetaInspector::TimeoutError
    ::OpenStruct.new(content_type: 'unknown')
  end

end
