
class Parser
  attr_reader :tags

  def initialize(str)
    @buffer = StringScanner.new(str)
    @tags   = []
    parse
  end

  def parse
    while !@buffer.eos?
      skip_spaces
      parse_element
    end
  end

  def parse_element
    if @buffer.peek(1) == "<"
      @tags << find_tag
      last_tag.content = find_content
    end
  end

  def skip_spaces
    @buffer.skip /\s+/
  end

  def find_tag
    @buffer.getch
    tag = @buffer.scan_until />/
    Tag.new(tag.chop)
  end

  def find_content
    tag = last_tag.name
    content = @buffer.scan_until /<\/#{tag}>/
    content.sub("</#{tag}>", "")
  end

  def first_tag
    @tags.first
  end

  def last_tag
    @tags.last
  end
end

class Tag
  attr_reader :name
  attr_accessor :content

  def initialize(name)
    @name = name
    @content
  end
end
