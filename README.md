# Ruby Mutant

[![Gem Version](https://badge.fury.io/rb/ruby-mutant.svg)](https://badge.fury.io/rb/ruby-mutant)


## Installation


```ruby
gem 'ruby-mutant', '~> 1.0.1'
```

---
## Usage

Ruby Mutant is a lightweight mutations library to help you encapsulate your business logic into decoupled, testable mutations.  With Ruby Mutant you can easily add executable code with validation, helping you decouple important logic from your application.

To create a mutation from a ruby object, include the ruby module `require "mutatant"`  



```ruby
require "mutant"

class RecipeCreatedMutation
  include Mutant
  
  required_attr :recipe

    #Define custom validators for our attributes
    def validate_name?
        true
    end

    # Required, this will execute our new mutation.
    def execute(args)
        # here, recipe is passe into out Class.run(recipe=Recipe.new) method
        if recipe.difficulty == 'godlike'
          recipe_service.send_alert_new_super_recipe_confirmation()
        end 
    end
end
```

---
To run a mutation definition:
```ruby
# run() excepts any number of parameters that you want to pass into your mutation
output = RecipeCreatedMutation.run(recipe: Recipe.new, obj2: obj2, ....)
```

Every mutation execution will return an `output` object.  This object contains information on the
mutation execution, and errors occurred or any metadata that's needed to be returned from the mutation, 
in the form of a hash.

Any meta data that needs to be returned can be added to the output object using the
helper method inside your mutation:

```ruby
class RecipeCreatedMutation
  include Mutant
...
    def execute(args)
      output.add_meta(:test, 'value')
    end

...

output = RecipeCreatedMutation.run()
output.meta[:test] # >> 'value'

```

```ruby
output = RecipeCreatedMutation.run(obj: obj1)
output.success? # >> true
output.errors # >>  [err1, err1, ...]
output.meta # > {:my => 'value', :other => 'value1'}
```

---
## How to use this library

### Rails:
We could define a folder structure such as this, for our rails Recipe web app:
```
/lib/use_cases/recipes/recipe_created_mutation.rb
/lib/use_cases/user/new_user_signed_up_mutation.rb
```

`recipe_created_mutation.rb`
```ruby
require 'mutant'

module UseCases::Recipes
  class RecipeCreatedMutation
    include Mutant

    required_attr :recipe

    def execute(args)
      if recipe.name.blank?
        puts 'whoops this recipe is bad'
      end
    end
  end

end
```

And in a controller, we can execute the mutation like so:

```ruby
class RecipesController < ApplicationController
  include UseCases::Recipes

 
    def create
        @recipe = Recipe.new(recipe_params)
        
        output = RecipeCreatedMutation.run(recipe: @recipe)
    
        if output.success?
          puts 'everything went super duper good'
        end
      end 

...
end
```


---


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/coreyjs/ruby-mutant. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

For more information on contributing, here:  [How To Contribute](https://github.com/coreyjs/ruby-mutant/blob/master/CONTRIBUTING.md)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## Special thanks to the inspiration for this library!

https://github.com/cypriss/mutations

https://github.com/omarish/mutations


