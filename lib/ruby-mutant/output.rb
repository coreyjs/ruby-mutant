module Mutant
    class Output
        attr_reader :success
        attr_accessor :meta, :errors

        def initialize(success=true, errors=[], meta={})
            @success = success
            @errors = errors
            @meta = meta
        end

        def add_meta(key, value)
            @meta[key] = value
        end

        def success?
            @success
        end
    end
end