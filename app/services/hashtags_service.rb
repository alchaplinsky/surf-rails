module HashtagsService

  extend self

  HASHTAG_REGEX = /(?:\s|^)(?:#(?!\d+(?:\s|$)))([[:alnum:]]+)(?=\s|$)/i

  def parse_tags(text)
    text.scan(HASHTAG_REGEX).flatten
  end

  def without_tags(text)
    text.gsub(HASHTAG_REGEX, '').strip
  end

end
