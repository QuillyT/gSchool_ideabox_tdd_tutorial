ENV['RACK_ENV'] = 'test'

require './test/test_helper'
require 'sinatra/base'
require 'rack/test'
require './lib/app'

class IdeaboxAppHelper < Minitest::Test
  include Rack::Test::Methods

  def app
    IdeaboxApp
  end

  def teardown
    IdeaStore.delete_all
  end

  def test_idea_list
    IdeaStore.save Idea.new("dinner", "spaghetti and meatballs")
    IdeaStore.save Idea.new("drinks", "imported beers")
    IdeaStore.save Idea.new("movie", "The Matrix")

    get '/'

    [
      /dinner/, /spaghetti/,
      /drinks/, /imported beers/,
      /movie/, /The Matrix/
    ].each do |content|
      assert_match content, last_response.body
    end
  end

  def test_create_idea
    post '/', title: 'costume', description: "scary vampire"

    assert_equal 1, IdeaStore.count

    idea = IdeaStore.all.first
    assert_equal "costume", idea.title
    assert_equal "scary vampire", idea.description
  end

  def test_edit_idea
    id = IdeaStore.save Idea.new('sing', 'happy songs')

    put "/ideas/#{id}", {title: 'yodle', description: 'joyful songs'}

    assert_equal 302, last_response.status

    idea = IdeaStore.find(id)
    assert_equal 'yodle', idea.title
    assert_equal 'joyful songs', idea.description
  end

  def test_delete_idea
    id = IdeaStore.save Idea.new('breathe', 'fresh air in the mountains')

    assert_equal 1, IdeaStore.count

    delete "/ideas/#{id}"

    assert_equal 302, last_response.status
    assert_equal 0, IdeaStore.count
  end

  def test_like_idea
    id = IdeaStore.save Idea.new('happy', 'tree friends')

    post "/ideas/#{id}/like"

    idea = IdeaStore.find(id)
    assert_equal 1, idea.rank
  end
end
