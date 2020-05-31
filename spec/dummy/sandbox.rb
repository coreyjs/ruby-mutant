require_relative './recipe'
require_relative './recipe_created_mutation'

puts 'test'

recipe = Recipe.new('Pizza', 'buffalo', 4)
puts recipe
output  = RecipeCreatedMutation.run(recipe: recipe,
                                     max_difficulty: 3,
                                    name: 'run method',
                                    active: false)
# puts output.inspect