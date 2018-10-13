require 'mutant'

puts 'hello world'

class MutationDuplicateAttrException < StandardError
    attr_reader :dup
    def initialize(msg='MutationDuplicateAttrException', dup=nil)
        @dup = dup
        super(msg)
    end
end

class MutationPropUndefined < StandardError
    attr_reader :prop
    def initialize(msg='MutaitonPropUndefined', prop=nil)
        @prop = prop
        super("#{msg} - #{prop}")
    end
end

class Output
    attr_reader :success, :errors
    def initialize(success, errors)
        @@success = success
        @errors = errors
    end

    def success?
        @@success
    end
end

class Base
    @props
    @errors
    
    attr_reader :output

    def self.success?
        @errors == nil || @error.length == 0
    end

    def self.run(*args)
        puts 'base.run'

        #compare all the props agains the mutations defined attributes
        @props.each do |p|
            present = args.any?{|arg| arg.key? p.first}
            if !present
                raise MutationPropUndefined.new(
                    msg='Undefined prop.  Not found in required or optional params', p)
            end
        end

        @output = Output.new(success=self.success?, @errors)
    end

    def self.set_attributes(param_type, &block)
        fields = yield block
        self.props
        fields.each do |k, klass|
            puts k, klass
            if @props.key?(k)
                raise MutationDuplicateAttrException.new(
                    msg='Mutation has recieved duplicate required attributes.', dup=k)
            else
                @props[k] = klass
            end           
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
        # todo, check for validation methods
        # prefixed with validate_{prop}? name
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
            product: Product,
            name: String
        }
    end

    def validate_name?
        true
    end

    # execute out mutation code that is
    # specific to ProductCreatedMutation
    def self.run(product)
        super
        puts 'running mutation business logic'
        
        # Do other logic

        @output
    end
end


p = Product.new
output  = ProductCreatedMutation.run(product: p, name: 'Brew', address: 'hello world')
puts output.success?