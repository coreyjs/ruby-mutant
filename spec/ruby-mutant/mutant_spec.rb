require "mutant"

class ProductCreatedEmptyMutation < Mutant::MutantBase
end

class ProductCreatedMutation < Mutant::MutantBase

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
end
