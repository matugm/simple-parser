
class Parser
  def initialize(str)
    @buffer = StringScanner.new(str)
    @tags   = []
    parse
  end

  def parse
    if @buffer.peek(1) == "<"
      @tags << find_tag
      first_tag.content = find_content
    end
  end

  def find_tag
    Tag.new(@buffer.scan_until />/)
  end

  def find_content
    @buffer.scan_until /<\//
  end

  def first_tag
    @tags.first
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
