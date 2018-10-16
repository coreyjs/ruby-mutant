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

class MutationValidationError < StandardError
    def initialize(msg='MutationValidationError', validator=nil)
        super("#{msg} - #{validator}")
    end
end

class Output
    attr_reader :success, :errors
    def initialize(success, errors)
        @success = success
        @errors = errors
    end

    def success?
        @success
    end
end

class Base
    
    attr_reader :output, :raise_on_error, :props, :errors

    def self.success?
        @errors == nil || @error.length == 0
    end

    def self.run(**args)
        puts 'base.run'
        ##puts @props
        #puts args.inspect
        #puts args.class

        args['_mutation_props_required'] = @props
        #puts args

        @output = new(args).run
    end

    def self.set_attributes(param_type, &block)
       # puts "self.set_attributes #{param_type}"
        fields = yield block
        self.props
        fields.each do |k, klass|
            #puts k, klass
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

    def self.validate(&block)
        methods = yield block
        methods.each do |m|
            begin
                #if self.superclass == Base
                
                puts singleton_methods
                #self.class.define_singleton_method(:validate_product_name) do end
               # result = singleton_class.send(:validate_product_name)
               # end
            
            rescue NoMethodError => e
                puts ("NoMethod Error - #{m} - Class: #{self.singleton_class}")
                if @raise_on_error
                    #Raise missing validator exception
                end
            end
        end
    end

    def self.test
        puts 'self.test'
    end

    def self.required(&block)
        self.set_attributes('required', &block)
    end

    def self.optional(*block)
        #TODO Add to props
        # check for dups, throw mutation error
    end

    def initialize(args)
        required_args = args['_mutation_props_required'].dup
        args.delete('_mutation_props_required')
        required_args.each do |k, v|
            present = args.key?(k)       
            if !present
                 raise MutationPropUndefined.new(
                    msg='Undefined prop.  Not found in required or optional params', p)
            end
        end

        # Validate all input args against their required class/type defination
        args.each do |k, v|
            if !v.class == required_args[k]
                if raise_on_error
                    raise MutationValidationError.new(msg='Property does not match its type', validator=v)
                end
            end
        end

        @output = Output.new(success?, @errors)
    end

    def run
        @output
    end


    protected
    def success?
        !@errors
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

    # execute out mutation code that is
    # specific to ProductCreatedMutation
    def self.run(*args)
        super
        puts 'running mutation business logic'
        
        
        # Do other logic

        @output
    end
end


p = Product.new
output  = ProductCreatedMutation.run(product: p, name: 'Brew', address: 'hello world')
puts output.inspect