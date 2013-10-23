require './test/test_helper'
require './lib/ideabox/idea'

class IdeaTest < Minitest::Test

  def test_basic_idea
    idea = Idea.new("title","description")
    assert_equal "title", idea.title
    assert_equal "description", idea.description
  end

  def test_ideas_can_be_liked_more_than_once
    idea = Idea.new("exercise", "stickfighting")
    assert_equal 0, idea.rank
    5.times do
      idea.like!
    end
    assert_equal 5, idea.rank
  end

  def test_ideas_can_be_sorted_by_rank
    diet = Idea.new("diet", "cabbage soup")
    exercise = Idea.new("exercise", "long distance running")
    drink = Idea.new("drink", "carrot smoothly")

    exercise.like!
    exercise.like!
    drink.like!

    ideas = [diet, exercise, drink]
    assert_equal [diet, drink, exercise], ideas.sort
  end

  def test_ideas_can_be_changed
    idea = Idea.new("money", "in the bank")
    idea.id = 5
    assert_equal 5, idea.id
    assert_equal "money", idea.title
    assert_equal "in the bank", idea.description
    idea.id = 7
    idea.title = "hello"
    idea.description = "world!"
    assert_equal 7, idea.id
    assert_equal "hello", idea.title
    assert_equal "world!", idea.description
  end

  def test_ideas_can_have_tags
    tag1 = Tag.new("CoOl")
    idea = Idea.new("holy", "cow that is fun!")
    idea.add_tag(tag1)
    assert "cool", idea.tags[0]

    tag2 = Tag.new("HoT")
    idea.add_tag(tag2)

    assert idea.tags.include?(tag1)
    assert idea.tags.include?(tag2)
    assert_equal 2, idea.tags.count
  end

end
