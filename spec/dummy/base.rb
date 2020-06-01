

gem 'byebug'
require 'byebug'


module Mutant
  def self.included(klass)
    puts "included #{klass}"
    klass.extend(ClassMethods)
  end

  module ClassMethods

    # run - The entry point, main method that will be execute any
    # mutation logic
    def run(args)
      puts 'Mutant::self.run(*args) '
      obj = new(args)
      obj.send(:validate)

      # set the vars to the obj dynamically
      args.each do |k, v|
        puts "Mutant::var check '#{k}', responds? #{obj.respond_to? k.to_sym}"

        # First make sure this mutation obj has the correct vars,
        # if not, then proceeed to create them
        unless obj.respond_to? k.to_sym
          puts 'Mutant: object does not have attribute'
          obj.instance_variable_set("@#{k.to_sym}", v)
          byebug
          puts "FINAL Mutant::var check '#{k}', responds? #{obj.respond_to? k.to_sym}"
        end

      end

        obj.execute(args)
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