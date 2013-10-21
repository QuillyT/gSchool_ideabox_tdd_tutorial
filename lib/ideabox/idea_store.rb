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
      all.size
    end

    def delete(id)
      all.delete_at(id)
    end

    def delete_all
      @all = []
    end
  end
end
