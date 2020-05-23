require 'ruby-mutant/base'

class RecipeCreatedMutation < Mutant::Base

  name = 'a'

  required do
    {
        name: String,
        address: String,
        product: Product
    }
  end


  def validate_name?
    puts 'I AM VALIDATE NAME'
    true
  end

  # execute out mutation code that is
  # specific to RecipeCreatedMutation
  def execute(*args)
    puts 'running mutation business logic'


    # Do other logic

    @output
  end
end
