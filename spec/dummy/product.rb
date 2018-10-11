require 'mutant'

puts 'hello world'

class Base
    @props
    @errors

    def success?
        !@errors
    end

    def self.run(*args)
        puts 'base.run'

        @props.each do |p|
            present = args.any?{|arg| arg.key? p.first}
            if !present
                #TODO Add error
            end
        end
    end

    def self.set_attributes(param_type, &block)
        fields = yield block
        self.props
        fields.each do |k, klass|
            #TODO Check for dup, throw mutation error
            @props[k] = klass
        end

    end

    def self.props
        @props ||= begin
            if Base == self.superclass
                {}
            else
                self.superclass.props.dup
            end
        end
    end

    # validate our required props equals whats inputed
    def self.validate_props(*args)

    end

    def self.required(&block)
        self.set_attributes('required', &block)
    end

    def self.optional(*block)
        #TODO Add to props
        # check for dups, throw mutation error
    end

end

class Product

    def initialize()
        @name = 'Beer'    
    end
end

class ProductCreatedMutation < Base

    required do
        {
            name: String, 
            address: String, 
            product: Product
        }
    end

    def validate_name?
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





p = Product.new
ProductCreatedMutation.run(product: p)