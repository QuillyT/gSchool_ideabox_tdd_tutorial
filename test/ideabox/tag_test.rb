require './test/test_helper'
require './lib/ideabox/tag'

class TagTest < Minitest::Test

  def test_tag_exists
    assert Tag
  end

  def test_tag_initializes
    tag = Tag.new("FUN")
    assert_equal "fun", tag.line
  end

end


