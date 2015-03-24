require_relative 'parsing'

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
  let(:parser) { Parser.new "<body>testing</body> <title>parsing with ruby</title>" }

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
end
