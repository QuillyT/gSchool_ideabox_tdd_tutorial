class Idea
  include Comparable

  attr_accessor :id, :title, :description, :rank, :tags

  def initialize(title, description)
    @title = title
    @description = description
    @rank = 0
    @tags = []
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    @rank <=> other.rank
  end

  def add_tag(tag)
    @tags << tag
  end

end
