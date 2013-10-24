class Tag
  attr_reader :line

  def initialize(line)
    @line = line.downcase
  end
end
