require_relative 'parsing'
require 'pry'

describe StringScanner do
  let (:buff) { StringScanner.new "testing" }

  it "can peek one step ahead" do
    expect(buff.peek 1).to eq "t"
  end

  it "can read one char and return it" do
    expect(buff.getch).to eq "t"
    expect(buff.getch).to eq "e"
  end
end

describe Parser do
  let(:parser) { Parser.new "<body>testing</body> <title>parsi<a>link</a>ng with ruby</title>" }

  it "can parse an HTML tag" do
    expect(parser.first_tag.name).to eq "body"
  end

  it "can find a tag content" do
    expect(parser.first_tag.content).to eq "testing"
  end

  it "can find more than one tag" do
    second_tag = parser.tags[1]
    expect(second_tag.name).to eq "title"
    expect(second_tag.content).to eq "parsing with ruby"
  end

  it "can find nested tags" do
    nested_tag = parser.tags[2]
    expect(nested_tag.content).to eq "link"
  end

  it "can build a node tree" do
    second_tag = parser.tags[1]
    expect(second_tag.children.size).to eq 1
  end

  let(:parser_complex) { Parser.new "<html><head>bbb<title>Page Title</title></head><h1>This is a Heading</h1><p>This is a paragraph.</p></html>" }

  it "can parse complex input" do
    tag_names = parser_complex.tags.map(&:name)
    expect(tag_names).to include "head"
    expect(tag_names).to include "title"
    expect(tag_names).to include "p"
  end
end
