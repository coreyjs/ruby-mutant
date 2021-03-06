require 'ruby-mutant/exceptions/mutation_validation_exception'
require 'ruby-mutant/exceptions/mutation_setup_exception'
require 'ruby-mutant/exceptions/mutation_missing_required_var_exception'
require 'ruby-mutant/output'
require "bundler/setup"


module Mutant
    attr_accessor :output

    def self.included(klass)
        klass.extend(ClassMethods)
    end

    module ClassMethods
        def required_attr(*attrs)
            puts 'Mutant::required_attr'
            # This defines a method called required_attr that will
            # return an array of symbols for all the properties of the
            # mutation that we should have defined.
            define_method(:required_attr) { attrs ||= [] }
        end

        # The entry point, main method that will be execute any mutation logic
        #
        # == Parameters:
        # args::
        #   A hash of inputs suppplied when the user runs the mutation.
        #   i.e. MyMutation.run(name: 'jon', house: 'stark')
        #
        # == Returns:
        #   An instance of `Mutant::Output`.  This object defines all
        #   errors, metadata and success definition of the mutation
        def run(args = {})
            unless args.has_key?(:raise_on_error)
                args[:raise_on_error] = true
            end
            args[:raise_on_error].freeze

            puts 'Mutant::self.run(*args) '
            obj = new(args)

            # Ensure the mutation has the correct method
            unless obj.respond_to?(:execute)
                raise MutationSetupException.new(msg='Missing execute method')
            end

            # 1. We want to run the validators first, then determine if we should continue
            errs = obj.send(:validate)
            obj.output.errors = obj.output.errors + errs
            if errs.length > 0
                if args[:raise_on_error]
                    raise MutationSetupException.new(msg='Validation failed')
                end
            end

            # 2. Check to see the mutation has the corresponding inst vars
            args.each do |k, val|
                puts "Mutant::var check '#{k}', responds? #{obj.respond_to? k.to_sym}"

                # First make sure this mutation obj has the correct vars,
                # if not, then proceeed to create them
                unless obj.respond_to? k.to_sym
                    # create the attr_accessor for the missing vars
                    obj.class.send(:define_method, "#{k}=".to_sym) do |value|
                        instance_variable_set("@" + k.to_s, value)
                    end
                    obj.class.send(:define_method, k.to_sym) do
                        instance_variable_get("@" + k.to_s)
                    end
                end

                # 3. Propagate the values from the mutation props to the class
                obj.send("#{k}=".to_sym, val)
            end

            # 3 If this instance defines :required_attr
            if obj.respond_to? :required_attr
                required_attr_errors = obj.send(:check_required_attrs)
                unless required_attr_errors.length == 0
                    # We need to handle any errors we get back from our
                    # required_attr validator
                    obj.output.errors += required_attr_errors
                    if args[:raise_on_error]
                        raise required_attr_errors[0]
                    end
                end
            end

            # 4. Run execute method to run mutation logic
            obj.execute(args)
            # Return out Output obj, with all meta data regarding the ran mutation
            obj.output
        end
    end

    def initialize(*args)
        @output = Output.new
    end

    private

    # This will run all ou validation functions on our mutation class.
    # This will return an array of MutationValidationException, to the class method, run()
    #
    # == Parameters:
    #
    # == Returns:
    #  errors.  An array of errors representing all validation methods that have failed.
    # (defaults to `[]`)
    def validate
        errors = []
        self.public_methods.each do |m|
            if m.to_s.start_with?('validate_') && m.to_s.end_with?('?')
                # execute validation method
                res = self.send(m)

                # unless the response is truthy
                unless res
                    errors << MutationValidationException.new(msg='Validator has returned false', validator=m)
                end
            end
        end
        errors
    end

    # Checks to see if any `required_attr` has been set, if so check to see if each one
    # is defined in either the .run() definition or the mutation's `attr_accesor`.
    # TODO need to also check that these required attributes have values
    #
    # == Parameters:
    #
    # == Returns:
    # An array of errors, of type `MutationMissingRequiredVarException`, for each
    # missing required attribute.
    def check_required_attrs
        # In this we need to compare what we define in
        # required_attr(*attrs) against what we have defined in
        # the mutation vs what we pass into the run() definition
        errors = []
        puts 'Mutant::check_required_attrs'
        self.required_attr.each do |attr|
            if !self.respond_to?(attr)
                # Our attribute is not defined on our mutation class
                # So we will build the error to return to the run()
                # method, which can determine how we proceed
                err = MutationMissingRequiredVarException.new(
                                    msg="A property that is marked as required is not defined on the mutation: #{attr}",
                                    prop=attr)
                errors << err
            end
        end
        errors
    end

end