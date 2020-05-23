require_relative './recipe'
require_relative './recipe_created_mutation'

puts 'test'

recipe = Recipe.new(name: 'Pizza', style: 'buffalo', difficulty: 4)
puts recipe
# output  = RecipeCreatedMutation.run(recipe: recipe,
#                                     max_difficulty: 3)
# puts output.inspect