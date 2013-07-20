module RandomToken

  # A customized exception for RandomToken
  class RandomTokenError < StandardError

    # Errors used in RandomToken
    ERRORS = {
      :unknown_seed => {
        :value => 1,
        :msg => "Unknown given seed"
      },
      :not_support_case => {
        :value => 2,
        :msg => "Case feature is not supported in this case, but the case option is given."
      },
      :not_support_friendly => {
        :value => 3,
        :msg => "Friendly feature is not supported in this case, but the friendly option is true."
      },
      :false_friendly_with_given_mask => {
        :value => 4,
        :msg => "The mask is given but the friendly option is false."
      },
      :invalid_strf_pattern => {
        :value => 5,
        :msg => "The given pattern is invalid."
      },
      :invalid_gen_arg => {
        :value => 6,
        :msg => "The given arg is invalid."
      }
    }

    attr_reader :code, :value, :msg, :info

    # The RandomTokenError constructor.
    # @param error [Fixnum, String]
    #   You can give a error number defined in the keys of {RandomToken::RandomTokenError::ERRORS} or a string message for internal usage.
    # @param info [Hash]
    #   Anything you want to put in the info attribute of RandomTokenError.
    def initialize(error, info = {})
      @code = error
      @info = info
      if ERRORS.keys.include?(error)
        @value = ERRORS[error][:value]
        @msg = ERRORS[error][:msg]
      elsif error.class.name == 'String'
        @code = :internal
        @value = 90000
        @msg = error
      else
        @code = :internal
        @value = 99999
        @msg = "Internal Error"
      end
    end

    # Override the message method to show more information in RandomTokenError
    def message
      "RandomTokenError(#{@code.to_s}): value = #{@value}, msg = #{@msg}, info = #{@info.inspect}"
    end
  end
end
