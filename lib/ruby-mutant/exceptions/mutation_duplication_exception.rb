class MutationDuplicateAttrException < StandardError
    attr_reader :dup
    def initialize(msg='MutationDuplicateAttrException', dup=nil)
        @dup = dup
        super(msg)
    end
end