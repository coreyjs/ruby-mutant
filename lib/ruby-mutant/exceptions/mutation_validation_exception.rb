class MutationValidationException < StandardError
    def initialize(msg='MutationValidationError', validator=nil)
        super("#{msg} - #{validator}")
    end
end