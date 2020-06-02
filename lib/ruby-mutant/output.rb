module Mutant
    class Output

        # Allows to reading the status of the executed mutation
        attr_reader :success

        # @return [Hash] the hash of metadata the user wants returned from the mutation execution
        attr_accessor :meta

        # @return [Array] The get/set for the mutations errors that have been thrown
        attr_accessor :errors

        # Output constructor
        #
        # == Parameters:
        # success::
        #   The successful state of the mutation that owns this object.  (defaults to `true`)
        # errors::
        #   An array of errors that can be packaged and wrapped in this object to be
        #   `returned` from the mutation's `execute` method. (defaults to `[]`)
        # meta::
        #   A hash map that can be used to set any information that needs to be returned
        #   from the mutation to the calling code.  (defaults to `{}`)
        #
        def initialize(success=true, errors=[], meta={})
            @success = success
            @errors = errors
            @meta = meta
        end

        # Adds meta data to the @meta hash
        # (will overwrite existing value)
        #
        # == Parameters:
        # key::
        #   A symbol that will be used to store the value in the hash
        #
        # value::
        #   Any value that you wish to store indexed by the `key` param.
        #   This can be used if you need to return data from the mutation's `execute` method
        #
        # == Returns:
        #   Nothing useful
        def add_meta(key, value)
            @meta[key] = value
        end

        # Helper method to determine successfulnes of the mutation that has ran.  A successful
        # mutation execution is defined by having an error count of 0.
        # TODO:  This needs to be handled better, more smart about what success means
        #
        # == Parameters:
        #
        # == Returns:
        #   A boolean that represents the status of the just execute mutation
        def success?
            @success
        end
    end
end