class IdeaStore
  class << self
    def save(idea)
      idea.id ||= next_id
      all[idea.id] = idea
      idea.id
    end

    def all
      @all ||= []
    end

    def find(id)
      all[id]
    end

    def count
      all.length
    end

    def next_id
      #all.size
      @counter ||= -1
      @counter += 1
    end

    def delete(id)
      all.delete_at(id)
    end

    def delete_all
      @all = []
      @counter = -1
    end

    def find_by_title(text)
      all.find do |idea|
        idea.title == text
      end
    end
  end
end
