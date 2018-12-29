require 'ruby-mutant/exceptions/mutation_duplicate_attr_exception'
require 'ruby-mutant/exceptions/mutation_prop_undefined'
require 'ruby-mutant/exceptions/mutation_validation_exception'
require 'ruby-mutant/mutant_output'

module Mutant
    class MutantBase
        attr_reader :output, :raise_on_error, :props, :errors
        attr_writer :errors

        def self.success?
            @errors == nil || @error.length == 0
        end

        def self.run(**args)
            args['_mutation_props_required'] = @props ? @props : {}
            args['_mutation_validate_methods'] = @validate_methods ? @validate_methods : []

            @output = new(args).run
        end

        def self.set_attributes(param_type, &block)
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
                if MutantBase == self.superclass
                    {}
                else
                    self.superclass.props.dup
                end
            end
        end

        def self.validate_methods
            @validate_methods ||= begin
                if MutantBase == self.superclass
                    []
                else
                    self.superclass.validate_methods.dup
                end
            end
        end
    
        def errors
            @errors ||= begin
                if MutantBase == self.superclass
                    []
                else
                    self.superclass.errors.dup
                end
            end
        end

        def self.validate(&block)
            methods = yield block
            self.validate_methods
            methods.each do |m|
                begin
                    self.class.define_method(m.to_sym) do end
                    self.validate_methods << m            
                rescue NoMethodError => e
                    puts ("NoMethod Error - #{m} - Class: #{self.singleton_class}")
                    if @raise_on_error
                        # Todo: Raise missing validator exception
                    end
                end
            end
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
            validator_methods = args['_mutation_validate_methods'].dup
            args.delete('_mutation_validate_methods')
            
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
                        raise MutationValidationException.new(msg='Property does not match its type', validator=v)
                    end
                end
            end

            self.errors = []
            validator_methods.each do |vm|
                begin
                    self.send(vm.to_sym)
                rescue => e
                    @errors << e
                end
            end
    
            @output = MutantOutput.new(success?, @errors)
        end

        def run
            @output
        end


        protected
        def success?
            !@errors || @errors.length == 0
        end
    end
end
