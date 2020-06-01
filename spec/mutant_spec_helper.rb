require "mutant"

module MutantHelpers
    class RecipeBrokenMutation
    include Mutant
  end

  class RecipeCreatedEmptyMutation
    include Mutant
    def execute(*args)

    end
  end

  class RecipeCreatedMutation
    include Mutant
    attr_accessor :first, :second

    def execute(*args)
      output.add_meta(:test, 'value')
    end
  end
end