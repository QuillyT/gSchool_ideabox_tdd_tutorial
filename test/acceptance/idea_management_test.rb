ENV['RACK_ENV'] = 'test'

require './test/test_helper'

require 'bundler'
Bundler.require
require 'rack/test'
require 'capybara'
require 'capybara/dsl'

require './lib/app'

Capybara.app = IdeaboxApp

Capybara.register_driver :rack_test do |app|
  Capybara::RackTest::Driver.new(app, :headers => { 'User-Agent' => 'Capybara' })
end

class IdeaManagementTest < Minitest::Test
  include Capybara::DSL

  def teardown
    IdeaStore.delete_all
  end

  # def test_manage_ideas
  #   visit '/'
  #   fill_in 'title', :with => 'eat'
  #   fill_in 'description', :with => 'chocolate chip cookies'
  #   click_button 'Save'
  #   assert page.has_content?("chocolate chip cookies"), "Idea is not on page"
  # end

  def test_manage_ideas
    # Create a couple of decoys
    # This is so we know we're editing the right thing later
    IdeaStore.save Idea.new("laundry", "buy more socks")
    IdeaStore.save Idea.new("groceries", "macaroni, cheese")

    # Create an idea
    visit '/'
    # The decoys are there
    assert page.has_content?("buy more socks"), "Decoy idea (socks) is not on page"
    assert page.has_content?("macaroni, cheese"), "Decoy idea (macaroni) is not on page"

    # Fill in the form
    fill_in 'title', :with => 'eat'
    fill_in 'description', :with => 'chocolate chip cookies'
    click_button 'Save'
    assert page.has_content?("chocolate chip cookies"), "Idea is not on page"

    # Find the idea - we need the ID to find
    # it on the page to edit it
    idea = IdeaStore.find_by_title('eat')

    # Edit the idea
    within("#idea_#{idea.id}") do
      click_link 'Edit'
    end

    assert_equal 'eat', find_field('title').value
    assert_equal 'chocolate chip cookies', find_field('description').value

    fill_in 'title', :with => 'eats'
    fill_in 'description', :with => 'chocolate chip oatmeal cookies'
    click_button 'Save'

    # Idea has been updated
    assert page.has_content?("chocolate chip oatmeal cookies"), "Updated idea is not on page"

    # Decoys are unchanged
    assert page.has_content?("buy more socks"), "Decoy idea (socks) is not on page after update"
    assert page.has_content?("macaroni, cheese"), "Decoy idea (macaroni) is not on page after update"

    # Original idea (that got edited) is no longer there
    refute page.has_content?("chocolate chip cookies"), "Original idea is on page still"

    # Delete the idea
    within("#idea_#{idea.id}") do
      click_button 'Delete'
    end

    refute page.has_content?("chocolate chip oatmeal cookies"), "Updated idea is not on page"

    # Decoys are untouched
    assert page.has_content?("buy more socks"), "Decoy idea (socks) is not on page after delete"
    assert page.has_content?("macaroni, cheese"), "Decoy idea (macaroni) is not on page after delete"
  end

  def test_ranking_ideas
    id1 = IdeaStore.save Idea.new("fun", "ride horses")
    id2 = IdeaStore.save Idea.new("vacation", "camping in the mountains")
    id3 = IdeaStore.save Idea.new("write", "a book about being brave")

    visit '/'

    idea = IdeaStore.all[1]
    idea.like!
    idea.like!
    idea.like!
    idea.like!
    idea.like!
    IdeaStore.save(idea)

    within("#idea_#{id2}") do
      3.times do
        click_button '+'
      end
    end

    within("#idea_#{id3}") do
      click_button '+'
    end

    # now check that the order is correct
    ideas = page.all('li')

    assert_match /camping in the mountains/, ideas[0].text
    assert_match /a book about being brave/, ideas[1].text
    assert_match /ride horses/, ideas[2].text
  end

  def test_tags_show
    IdeaStore.save Idea.new("fun", "ride horses")
    tag1 = Tag.new("cool")
    tag2 = Tag.new("hot")
    tag3 = Tag.new("music")

    visit '/'

    assert page.has_content?("cool"), "Tag 'cool' is not showing."
    assert page.has_content?("hot"), "Tag 'hot' is not showing."
    assert page.has_content?("stuff"), "Tag 'music' is not showing."

  end
end
