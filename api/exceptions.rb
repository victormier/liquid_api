class LiquidApi
  # This exception should be raised any time a mutation is invalid
  # because of the data.
  #
  # raise LiquidApi::MutationInvalid.new("Optional message", errors: { "age": "should be over 18 years old" })
  #
  class MutationInvalid < StandardError
    attr_reader :errors

    def initialize(message = nil, data)
      @message = message || "The data mutation is invalid"
      @errors = data[:errors]
    end

    def to_s
      @message
    end
  end
end
