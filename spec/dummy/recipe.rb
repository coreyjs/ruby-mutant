class Recipe
  attr_accessor :name, :style, :difficulty
  def initialize(name, style, difficulty)
      @name = name
      @style = style
      @difficulty = difficulty
  end

  def easy?
      @difficulty < 2
  end

  def sorta_easy?
      @difficulty >=2 && @difficulty < 4
  end

  def hard_mode?
      @difficulty >= 4
  end
end