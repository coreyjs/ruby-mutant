require_relative './base'

class RecipeCreatedMutation
  include Mutant

  attr_accessor :name, :recipe, :max_difficulty

  @name = 'inside class defined'

  # @@name = 'a'
  # @@recipe
  # @@max_difficulty

  # def initialize(*args)
  #   puts 'class init'
  # end

  # required do
  #   {
  #       name: String,
  #       address: String,
  #       product: Product
  #   }
  # end


  def validate_name?
    puts 'I AM VALIDATE NAME'
    true
  end

  # execute out mutation code that is
  # specific to RecipeCreatedMutation
  def execute(*args)
    puts 'running mutation business logic'
    puts "name = #{name}"
    puts "The Recipe is #{recipe&.name}"

    # Do other logic

    @output
  end
end
