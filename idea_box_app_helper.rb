require './test/test_helper'
require 'sinatra/base'
require 'rack/test'
require './lib/app'

class IdeaboxAppHelper < Minitest::Test
  include Rack::Test::Methods

  def app
    IdeaboxApp
  end

  def test_hello
    get '/'
    assert_equal "Hello, World!", last_response.body
  end
end
