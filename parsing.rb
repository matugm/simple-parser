
class Parser
  attr_reader :tags

  def initialize(str)
    @buffer = StringScanner.new(str)
    @tags   = []
    @queue  = []
    parse
  end

  def parse
    while !@buffer.eos?
      skip_spaces
      parse_element
    end

    while @queue.any?
      parse_nested_tags
    end
  end

  def parse_element
    if @buffer.peek(1) == "<"
      @tags << find_tag
      last_tag.content = find_content

      @queue << last_tag if last_tag.content.match /<\w+/
    end
  end

  def parse_nested_tags
    @buffer.clear
    parent_tag = @queue.pop
    @buffer << parent_tag.content

    # Skip text and spaces, this should put the pointer in front of the next tag
    @buffer.skip /[\w\s]+/
    parse_element

    # Remove the tag we just parsed from the parent tag content
    parent_tag.content = parent_tag.content.sub(/<#{last_tag.name}>.*<\/#{last_tag.name}>/, "")

    # Add the contents again to the queue if there are more nested tags to parse
    @queue << parent_tag if parent_tag.content.match /<\w+/

    # Add the tag we just parsed as a child
    parent_tag.children << last_tag
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
  attr_accessor :content, :children

  def initialize(name)
    @name = name
    @children = []
  end
end
