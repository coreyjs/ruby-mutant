require "mutant"

class ProductCreatedEmptyMutation
  include Mutant
end

class ProductCreatedMutation
  include Mutant

  def execute

  end
end

RSpec.describe Mutant do
  before do
    
  end

  it "has a version number" do
    expect(Mutant::VERSION).not_to be nil
  end

  it "should pass successfully with no data and return an output object" do
    output = ProductCreatedEmptyMutation.run()
    expect(output).to_not be_nil
    expect(output.success?).to eq(true)
  end

  it "should throws error if raise_on_error is true, or not set" do

  end

  it "should not throw error if raise_on_error is false" do

  end

  it "should fail if not all required properties are present" do
    expect { raise ProductCreatedMutation.run() }.to raise_error(MutationPropUndefined)
  end

  it "should create accessors for properties defined in run() that are missing on class definition" do

  end

  it "should set the values of the class mutation based on the props supplied to run()" do

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
