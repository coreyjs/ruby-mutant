class Output
    attr_reader :success, :errors, :payload
    attr_writer :payload
    
    def initialize(success, errors)
        @success = success
        @errors = errors
    end

    def success?
        @success
    end
end