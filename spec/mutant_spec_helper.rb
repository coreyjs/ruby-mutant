require "mutant"

module MutantHelpers
    class RecipeBrokenMutation
    include Mutant
  end

  class RecipeCreatedEmptyMutation
    include Mutant
    def execute(args)

    end
  end

  class RecipeCreatedMutation
    include Mutant
    attr_accessor :first, :second
    required_attr :first, :second, :third

    def validate_true?
      true
    end

    def execute(args)
      output.add_meta(:test, 'value')
    end
  end

  class RecipeInvalidMutation
    include Mutant
    attr_accessor :first, :second

    def validate_false?
      'abc' == 'xyz'
    end

    def validate_true?
      true
    end

    def execute(args)
      output.add_meta(:test, 'value')
    end
  end

end