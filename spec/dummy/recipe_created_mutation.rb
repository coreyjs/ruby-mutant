#require_relative './base'
require "bundler/setup"
require_relative "../../lib/mutant"

class RecipeCreatedMutation
  include Mutant

  attr_accessor :name, :recipe, :max_difficulty

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

  end
end
