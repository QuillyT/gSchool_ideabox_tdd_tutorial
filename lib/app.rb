require 'bundler'
Bundler.require
require './lib/ideabox'

class IdeaboxApp < Sinatra::Base
  set :method_override, true
  set :root, "./lib/app"

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all}
  end

  get '/:id' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  post '/' do
    idea = Idea.new(params[:title], params[:description])
    IdeaStore.save(idea)
    redirect '/'
  end

  put '/:id' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.title = params[:title]
    idea.description = params[:description]
    IdeaStore.save(idea)
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end
end
