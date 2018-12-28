class MutantOutput
    attr_reader :success, :errors
    def initialize(success, errors)
        @success = success
        @errors = errors
    end

    def success?
        @success
    end
end