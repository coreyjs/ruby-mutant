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

      def validate_true?
        'abc' == 'xyz'
      end

      def execute(args)
        output.add_meta(:test, 'value')
      end
    end

end