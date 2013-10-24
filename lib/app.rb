require 'bundler'
Bundler.require
require './lib/ideabox'

class IdeaboxApp < Sinatra::Base
  set :method_override, true
  set :root, "./lib/app"

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all.sort.reverse}
  end

  post '/' do
    idea = Idea.new(params[:title], params[:description])
    params[:tags].to_s.split(',').each do |line|
      line.strip!
      unless line.length == 0
        idea.add_tag(Tag.new(line))
      end
    end
    IdeaStore.save(idea)
    redirect '/'
  end

  put '/ideas/:id' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.title = params[:title]
    idea.description = params[:description]
    IdeaStore.save(idea)
    redirect '/'
  end

  delete '/ideas/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  post '/ideas/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.save(idea)
    redirect '/'
  end

  get '/ideas/:id' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

end
