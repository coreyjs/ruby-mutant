class MutationPropUndefined < StandardError
    attr_reader :prop
    def initialize(msg='MutaitonPropUndefined', prop=nil)
        @prop = prop
        super("#{msg} - #{prop}")
    end
end