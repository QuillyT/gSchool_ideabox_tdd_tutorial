require 'yaml/store'

class IdeaStore
  class << self
    def save(idea)
      idea.id ? update(idea) : create(idea)
    end

    def create(idea)
      idea.id = next_id
      database.transaction do
        database['ideas'] << idea
      end
      idea.id
    end

    def update(idea)
      database.transaction do
        database['ideas'][idea.id] = idea
      end
      idea.id
    end

    def all
      database.transaction do |db|
        db['ideas'] || []
      end
    end

    def find(id)
      database.transaction do
        database['ideas'].find { |idea| idea.id == id }
      end
    end

    def count
      all.length
    end

    def next_id
      database.transaction do
        @database['next_id'] ||= -1
        @database['next_id'] += 1
      end
    end

    def delete(id)
      database.transaction do
        database['ideas'].delete_if{ |idea| idea.id==id }
      end
    end

    def delete_all
      database.transaction do
        database['ideas'] = []
        database['next_id'] = -1
      end
    end

    def find_by_title(text)
      all.find do |idea|
        idea.title == text
      end
    end

    def database
      return @database if @database
      @database ||= YAML::Store.new "ideabox_#{environment}"
      @database.transaction do
        @database['ideas'] ||= []
      end
      @database
    end

    def environment
      ENV['RACK_ENV'] || 'development'
    end
  end
end
