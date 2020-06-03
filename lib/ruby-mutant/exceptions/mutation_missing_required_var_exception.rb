 class MutationMissingRequiredVarException < StandardError
  attr_reader :prop
  def initialize(msg='MutationMissingRequiredVarException', prop=nil)
    @prop = prop
    super("#{msg} - #{prop}")
  end
end