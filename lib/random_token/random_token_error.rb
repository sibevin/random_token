module RandomToken
  class RandomTokenError < StandardError
    ERRORS = {
      :unknown_seed => {
        :status => :failed,
        :value => 1,
        :msg => "Unknown given seed"
      },
      :not_support_case => {
        :status => :failed,
        :value => 2,
        :msg => "Case feature is not supported in this case, but the case option is given."
      },
      :not_support_friendly => {
        :status => :failed,
        :value => 3,
        :msg => "Friendly feature is not supported in this case, but the friendly option is true."
      },
      :false_friendly_with_given_mask => {
        :status => :failed,
        :value => 4,
        :msg => "The mask is given but the friendly option is false."
      },
      :invalid_strf_pattern => {
        :status => :failed,
        :value => 5,
        :msg => "The given pattern is invalid."
      },
      :invalid_gen_arg => {
        :status => :failed,
        :value => 6,
        :msg => "The given arg is invalid."
      }
    }

    attr_reader :code, :value, :msg, :info, :status

    def initialize(error, info = {})
      @code = error
      @info = info
      @status = :failed
      if ERRORS.keys.include?(error)
        @value = ERRORS[error][:value]
        @msg = ERRORS[error][:msg]
        @status = ERRORS[error][:status]
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

    def message
      "RandomTokenError(#{@code.to_s}): value = #{@value}, status = #{@status.to_s}, msg = #{@msg}, info = #{@info.inspect}"
    end
  end
end
