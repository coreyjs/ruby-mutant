require "mutant"

class RecipeBrokenMutation
include Mutant
end

class RecipeCreatedEmptyMutation
  include Mutant
  def execute(*args)

  end
end

class RecipeCreatedMutation
  include Mutant
  attr_accessor :first, :second

  def execute(*args)
    output.add_meta(:test, 'value')
  end
end

RSpec.describe Mutant do
  before do
    
  end

  describe "core gem" do
    it "has a version number" do
      expect(Mutant::VERSION).not_to be nil
    end
  end

  describe "An empty mutation" do
    let(:output) { RecipeCreatedEmptyMutation.run() }

    context "can still execute with no data" do
      it "should pass successfully with no data and return an output object" do
        expect(output).to_not be_nil
        expect(output.success?).to eq(true)
      end
    end
  end

  describe "A mutatation - " do
    let(:output) {RecipeCreatedMutation.run() }

    context "is a valid mutation -" do
      it "should set the values of the class mutation based on the props supplied to run()" do
        expect(output).to_not be_nil
        expect(output.meta).to_not be_nil
        expect(output.meta[:test]).to eq 'value'
      end

      it "should throws error if raise_on_error is true, or not set" do
      end

      it "should create accessors for properties defined in run() that are missing on class definition" do
      end

      it "should not throw error if raise_on_error is false" do
      end
    end

    context "an invalid mutation" do
      it "should raise an error if execute is missing" do
        expect { raise RecipeBrokenMutation.run() }.to raise_error(MutationSetupException)
      end

      it "should fail if not all required properties are present" do
        #expect { raise ProductCreatedMutation.run() }.to raise_error(MutationPropUndefined)
      end
    end
  end

  describe "A mutation with input parameters" do
    let(:output) { RecipeCreatedMutation.run(name: 'Corey', skill_level: 100) }
  end

  # it "should pass if all required properties are present" do
  #   output = ProductCreatedMutation.run(name: 'Beer Bottle', code: '02AM4D', number: 1)
  #   expect(output).to_not be_nil
  #   expect(output.success?).to eq(true)
  #   expect(output.payload).to eq('Beer Bottle.02AM4D')
  # end

  # it "should validate that all properties are of the correct type" do
  #   expect { raise ProductCreatedMutation.run(name: 'Beer Bottle', code: '02AM4D', number: 'AA') }.to raise_error(MutationValidationException)
  # end


end
