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

  #def test_hello
  #  get '/'
  #  assert_equal "Hello, World!", last_response.body
  #end

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
end
