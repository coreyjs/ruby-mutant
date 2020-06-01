#require_relative './base'
require "bundler/setup"
require_relative "../../lib/mutant"
require 'byebug'

class RecipeCreatedMutation
  include Mutant

  attr_accessor :name, :recipe, :max_difficulty


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

  # def validate
  #   puts 'hello'
  #   byebug
  # end
end
