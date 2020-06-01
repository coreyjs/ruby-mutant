require 'ruby-mutant/exceptions/mutation_duplicate_attr_exception'
require 'ruby-mutant/exceptions/mutation_prop_undefined'
require 'ruby-mutant/exceptions/mutation_validation_exception'
require 'ruby-mutant/exceptions/mutation_setup_exception'
require 'ruby-mutant/output'


module Mutant
    attr_accessor :output

    def self.included(klass)
        klass.extend(ClassMethods)
    end

    module ClassMethods
        # run - The entry point, main method that will be execute any
        # mutation logic
        def run(args = {})
            errors = []
            unless args[:raise_on_error]
                args[:raise_on_error] = true
            end

            puts 'Mutant::self.run(*args) '
            obj = new(args)

            # Ensure the mutation has the correct method
            unless obj.respond_to?(:execute)
                raise MutationSetupException.new(msg='Missing execute method')
            end

            # 1. We want to run the validators first, then determine if we should continue
            obj.send(:validate)

            # 2. Check to see the mutation has the corresponding inst vars
            args.each do |k, val|
                puts "Mutant::var check '#{k}', responds? #{obj.respond_to? k.to_sym}"

                # First make sure this mutation obj has the correct vars,
                # if not, then proceeed to create them
                unless obj.respond_to? k.to_sym
                    puts 'Mutant: object does not have attribute'
                    # create the attr_accessor for the missing vars
                    obj.class.send(:define_method, "#{k}=".to_sym) do |value|
                        instance_variable_set("@" + k.to_s, value)
                    end
                    obj.class.send(:define_method, k.to_sym) do
                        instance_variable_get("@" + k.to_s)
                    end
                    puts "FINAL Mutant::var check '#{k}', responds? #{obj.respond_to? k.to_sym}"
                end

                # 3. Propagate the values from the mutation props to the class
                obj.send("#{k}=".to_sym, val)
            end

            obj.execute(args)

            # Return out Output obj, with all meta data regarding the ran mutation
            obj.output
        end
    end

    def initialize(*args)
        puts 'Mutant::initialize'
        @output = Output.new
    end

    # def execute
    #     raise '.execute(*args) method is not defined'
    # end

    private
    def validate
        puts 'Mutant::validate'
    end

end