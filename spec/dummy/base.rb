gem 'byebug'
require 'byebug'

module Mutant
  class Output
    attr_reader :success, :errors, :payload
    attr_writer :payload

    def initialize(success, errors)
      @success = success
      @errors = errors
    end

    def success?
      @success
    end
  end
end

module Mutant
  def self.included(klass)
    puts "included #{klass}"
    klass.extend(ClassMethods)
  end

  module ClassMethods
    # run - The entry point, main method that will be execute any
    # mutation logic
    def run(args)
      unless args[:raise_on_error]
        args[:raise_on_error] = true
      end

      puts 'Mutant::self.run(*args) '
      obj = new(args)

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
      Output.new(true, {})
    end
  end

  def initialize(*args)
    puts 'Mutant::initialize'
  end

  def execute
    raise '.execute(*args) method is not defined'
  end

  private
  def validate
    puts 'Mutant::validate'
  end


end