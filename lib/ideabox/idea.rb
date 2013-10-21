class Idea
  include Comparable

  attr_accessor :id, :title, :description, :rank

  def initialize(title, description)
    @title = title
    @description = description
    @rank = 0
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    @rank <=> other.rank
  end

end
