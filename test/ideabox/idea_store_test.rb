ENV['RACK_ENV'] = 'test'

require './test/test_helper'
require './lib/ideabox/idea'
require './lib/ideabox/idea_store'

class IdeaStoreTest < Minitest::Test

  def teardown
    IdeaStore.delete_all
  end

  def test_save_and_retrieve_an_idea
    idea = Idea.new("celebrate", "with champagne")
    id = IdeaStore.save(idea)

    assert_equal 1, IdeaStore.count

    idea = IdeaStore.find(id)
    assert_equal "celebrate", idea.title
    assert_equal "with champagne", idea.description
  end

  def test_save_and_retrieve_one_of_many
    #skip
    idea1 = Idea.new("relax", "in the sauna")
    idea2 = Idea.new("inspiration", "looking at the stars")
    idea3 = Idea.new("career", "translate for the UN")
    id1 = IdeaStore.save(idea1)
    id2 = IdeaStore.save(idea2)
    id3 = IdeaStore.save(idea3)

    assert_equal 3, IdeaStore.count

    idea = IdeaStore.find(id2)
    assert_equal "inspiration", idea.title
    assert_equal "looking at the stars", idea.description
  end

  def test_update_idea
    #skip
    idea = Idea.new("drink", "tomato juice")
    id = IdeaStore.save(idea)

    idea = IdeaStore.find(id)
    idea.title = "cocktails"
    idea.description = "spicy tomato juice with vodka"

    IdeaStore.save(idea)

    assert_equal 1, IdeaStore.count

    idea = IdeaStore.find(id)
    assert_equal "cocktails", idea.title
    assert_equal "spicy tomato juice with vodka", idea.description

    assert_equal 1, IdeaStore.count
  end

  def test_delete_an_idea
    #skip
    id1 = IdeaStore.save Idea.new("song", "99 bottles of beer")
    id2 = IdeaStore.save Idea.new("gift", "micky mouse belt")
    id3 = IdeaStore.save Idea.new("dinner", "cheeseburger with bacon and avocado")

    assert_equal ["song", "gift", "dinner"], IdeaStore.all.map(&:title)
    IdeaStore.delete(id2)
    assert_equal ["song", "dinner"], IdeaStore.all.map(&:title)
  end

  def test_find_by_title
    IdeaStore.save Idea.new("dance", "like it's the 80s")
    IdeaStore.save Idea.new("sleep", "like a baby")
    IdeaStore.save Idea.new("dream", "like anything is possible")

    idea = IdeaStore.find_by_title("sleep")

    assert_equal "like a baby", idea.description
  end

  def test_database_exists
    assert IdeaStore.database
  end

  def test_database_is_correct_type
    assert_kind_of YAML::Store, IdeaStore.database
  end

  def test_it_creates_an_idea_and_stores_it_in_the_yaml_file
    assert_equal 0, IdeaStore.count
    id = IdeaStore.create Idea.new("blue", "smurfs are small")

    assert_equal 1, IdeaStore.count
    assert_equal "blue", IdeaStore.find(id).title
    assert_equal "smurfs are small", IdeaStore.find(id).description

    IdeaStore.save Idea.new("dance", "like it's the 80s")
    IdeaStore.save Idea.new("sleep", "like a baby")
    id = IdeaStore.save Idea.new("dream", "like anything is possible")

    assert_equal 4, IdeaStore.count
    assert_equal "dream", IdeaStore.find(id).title
    assert_equal "like anything is possible", IdeaStore.find(id).description
  end

  def test_it_finds_yaml_index_of_existing_idea
    idea = Idea.new("sleep", "like a baby")
    IdeaStore.save Idea.new("dance", "like it's the 80s")
    IdeaStore.save idea
    IdeaStore.save Idea.new("dream", "like anything is possible")

    assert_equal 1, IdeaStore.get_index_of(idea)
  end

end
