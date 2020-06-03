# RubyMutant (master is deprecated, new release coming 6/2020)
[![Build Status](https://travis-ci.org/coreyjs/ruby-mutant.svg?branch=master)](https://travis-ci.org/coreyjs/ruby-mutant)



## Installation


```ruby
gem 'ruby-mutant'
```


## Usage

Ruby Mutant is a lightweight mutations library to help you encapsulate your business logic.  With Ruby Mutant you can easily add executable code with validation, helping you decouple important logic from your application.

To create a mutation from a ruby object, include the module `include Mutatant`  


```ruby
require "mutant"

class RecipeCreatedMutation
  include Mutant

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
output = RecipeCreatedMutation.run(obj: obj1, obj2: obj2, ....)
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
output.success?
output.errors
output.meta
```



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/coreyjs/ruby-mutant. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## Special thanks to the inspiration for this library!

https://github.com/cypriss/mutations

https://github.com/omarish/mutations


