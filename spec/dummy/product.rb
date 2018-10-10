require 'mutant'

puts 'hello world'

class ProductCreatedMutation < Mutant::MutantBase

    def validate_name
        true
    end

    # execute out mutation code that is
    # specific to ProductCreatedMutation
    def self.run(product)
        super
        puts 'child'
        puts product
        # Do other logic
    end
end

class Product

    def initialize()
        @name = 'Beer'
        ProductCreatedMutation.run(product: self)
    end
end



p = Product.new
