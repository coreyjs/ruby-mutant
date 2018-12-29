# RubyMutant
[![Build Status](https://travis-ci.org/coreyjs/ruby-mutant.svg?branch=master)](https://travis-ci.org/coreyjs/ruby-mutant)



## Installation


```ruby
gem 'ruby-mutant'
```


## Usage

Ruby Mutant is a lightweight mutations library to help you encapsulate your business logic.  With Ruby Mutant you can easily add executable code with validation, helping you decouple important logic from your application.

To create a mutation, subclass `MutatantBase`  

```ruby
class ProductCreatedMutation < MutantBase

    #Define required attributes for this mutation to execute
    required do
        {
            name: String, 
            address: String, 
            product: Product,
            name: String
        }
    end
    
    validate do 
        [:validate_name?]
    end

    #Define custom validators for our attributes
    def validate_name?
        true
    end

    # Requried, this will execute our new mutation.
    def self.run(product)
        super
        
        # Put all our mutation logic here!
        self.product.on_sale = true

        @output
    end
end
```



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/coreyjs/ruby-mutant. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


