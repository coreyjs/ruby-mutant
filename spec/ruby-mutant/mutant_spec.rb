require "mutant"

class ProductCreatedEmptyMutation < Mutant::Base
end

class ProductCreatedMutation < Mutant::Base
  required do 
    {
      name: String,
      code: String,
      number: Integer
    }
  end

  def self.run(*args)
    super
    input = args[0].to_h
    @output.payload = "#{input[:name]}.#{input[:code]}"
    @output
  end
end

RSpec.describe Mutant do
  before do
    
  end

  it "has a version number" do
    expect(Mutant::VERSION).not_to be nil
  end

  it "should pass successfully with no data" do
    output = ProductCreatedEmptyMutation.run()
    expect(output).to_not be_nil
    expect(output.success?).to eq(true)
  end

  it "should fail if not all required properties are present" do
    expect { raise ProductCreatedMutation.run() }.to raise_error(MutationPropUndefined)
  end

  it "should pass if all required properties are present" do
    output = ProductCreatedMutation.run(name: 'Beer Bottle', code: '02AM4D', number: 1)
    expect(output).to_not be_nil
    expect(output.success?).to eq(true)
    expect(output.payload).to eq('Beer Bottle.02AM4D')
  end

  it "should validate that all properties are of the correct type" do    
    expect { raise ProductCreatedMutation.run(name: 'Beer Bottle', code: '02AM4D', number: 'AA') }.to raise_error(MutationValidationException)
  end


end
