require "random_token/random_token_error"
require "securerandom"

module RandomToken

  # The number seed
  NUMBERS = ('0'..'9')

  # The alphabet seed
  ALPHABETS = ('A'..'Z')

  # The default friendly mask
  MASK = ['1', 'I', 'l', 'i', '0', 'O', 'o', 'Q', 'D',
          'C', 'c', 'G', '9', '6', 'U', 'u', 'V', 'v',
          'E', 'F', 'M', 'N', '8', 'B']

  # The default option definition
  DEFAULT_OPT = {
    :seed => nil,
    :friendly => false,
    :case => :mixed
  }

  # The default seeds definition
  SEED_TYPES = {
    :default => {
      :abbr => [nil],
      :seed => [NUMBERS, ALPHABETS],
      :support_friendly => true,
      :support_case => true,
      :default_case => :mixed
    },
    :alphabet => {
      :abbr => [:letter, :a, :l],
      :seed => [ALPHABETS],
    },
    :number => {
      :abbr => [:n, 1, 10],
      :seed => [NUMBERS],
      :support_case => false
    },
    :binary => {
      :abbr => [:b, 2],
      :seed => [('0'..'1')],
      :support_case => false,
      :support_friendly => false
    },
    :oct => {
      :abbr => [:o, 8],
      :seed => [('0'..'7')],
      :support_case => false,
      :support_friendly => false
    },
    :hex => {
      :abbr => [:h, 16],
      :seed => [NUMBERS, ('A'..'F')],
      :support_friendly => false,
      :default_case => :up
    }
  }

  # The supported options
  SUPPORTED_OPTS = {
    :seed => {
      :abbr => :s
    },
    :case => {
      :abbr => :c,
      :value => [:up, :u, :down, :d, :mixed, :m]
    },
    :mask => {
      :abbr => :m
    },
    :friendly => {
      :abbr => :f,
      :value => [true, false]
    }
  }

  # The directives used in the format string
  STRF_ARG_MAP = {
    'A' => { :seed => :alphabet, :case => :up },
    'a' => { :seed => :alphabet, :case => :down },
    'n' => { :seed => :number },
    'b' => { :seed => :binary },
    'o' => { :seed => :oct },
    'h' => { :seed => :hex, :case => :down },
    'H' => { :seed => :hex, :case => :up },
    'X' => { :case => :up },
    'x' => { :case => :down },
    '?' => {}
  }

  class << self
    # The major method to generate a random token.
    # @param arg [Fixnum, String]
    #   To give a token length or the string format for generating token.
    # @param options [Hash]
    #   The options to modify the token.
    #   Three options :seed, :friendly and :case are supported.
    #   Please see {file:README} to get more examples
    # @return [String]
    #   The generated token.
    # @raise [RandomTokenError]
    #   Please see {RandomToken::RandomTokenError}
    def gen(arg, options = {})
      arg_dispatcher(arg, options) do |length, seeds|
        (0...length).map{ seeds[SecureRandom.random_number(seeds.length)] }.join
      end
    end

    # A convenient method to generate a friendly token. It would call {RandomToken.gen} with :friendly => true option.
    # @param arg (see RandomToken.gen)
    # @param options (see RandomToken.gen)
    # @return (see RandomToken.gen)
    # @raise (see RandomToken.gen)
    def genf(arg, options = {})
      gen(arg, { :friendly => true }.merge(options))
    end

    # TODO: Add count feature
=begin
    # Count the number of token combination with given arg and options.
    # @param arg (see RandomToken.gen)
    # @param options (see RandomToken.gen)
    # @return [Fixnum] the number of combination
    # @raise (see RandomToken.gen)
    def count(arg, options = {})
      arg_dispatcher(arg, options, true) do |length, seeds|
        seeds.length ** length
      end
    end
=end

    # An old method for downward compatibility and it should be discarded.
    # Use "gen" instead.
    # @param arg (see RandomToken.gen)
    # @param options (see RandomToken.gen)
    # @return (see RandomToken.gen)
    # @raise (see RandomToken.gen)
    def get(arg, options = {})
      gen(arg, options)
    end

    # An old method for downward compatibility and it should be discarded.
    # Use "gen" instead.
    # @param arg (see RandomToken.gen)
    # @param options (see RandomToken.gen)
    # @return (see RandomToken.gen)
    # @raise (see RandomToken.gen)
    def strf(arg, options = {})
      gen(arg, options)
    end

    private

    # Decide how to generate/count token according to the arg type.
    def arg_dispatcher(arg, options, count = false)
      options = check_opt(options)
      unless block_given?
        raise RandomTokenError.new(
          "No block is given when calling arg_dispatcher.")
      end
      if arg.is_a?(Fixnum)
        run_by_length(arg, options) do |length, seeds|
          yield(length, seeds)
        end
      elsif arg.is_a?(String)
        result = run_by_pattern(arg, options) do |length, seeds|
          yield(length, seeds)
        end
        return result.join
        # TODO: Add count feature
=begin
        if count
          return result.delete_if { |x| x.is_a?(String) }.inject(0, :*)
        else
          return result.join
        end
=end
      else
        raise RandomTokenError.new(:invalid_gen_arg, arg)
      end
    end

    # Generate/count token with a given length.
    def run_by_length(length, options)
      if block_given?
        seeds = gen_seeds(options)[:seed]
        yield(length, seeds)
      else
        raise RandomTokenError.new(
          "No block is given when calling run_by_length.")
      end
    end

    # Generate/count token with a format string.
    def run_by_pattern(pattern, options = {})
      unless block_given?
        raise RandomTokenError.new(
          "No block is given when calling run_by_pattern.")
      end
      in_arg = false
      result = []
      length = ''
      pattern.split(//).each do |x|
        if x == '%'
          if in_arg
            result << x * (length == "" ? 1 : length.to_i)
            length = ''
            in_arg = false
          else
            in_arg = true
          end
        elsif ('0'..'9').include?(x)
          if in_arg
            length << x
          else
            result << x
          end
        elsif STRF_ARG_MAP.keys.include?(x)
          if in_arg
            seeds = gen_seeds(STRF_ARG_MAP[x].merge(options))[:seed]
            result << yield((length == "") ? 1 : length.to_i, seeds)
            length = ''
            in_arg = false
          else
            result << x
          end
        else
          if in_arg
            raise RandomTokenError.new(:invalid_strf_pattern, pattern)
          else
            result << x
          end
        end
      end
      result
    end

    # Check options
    def check_opt(opts)
      SUPPORTED_OPTS.each do |key, value|
        if opts[key] && opts.keys.include?(value[:abbr])
          raise RandomTokenError.new(:duplicated_option, opts)
        end
        opts.merge!(key => opts[value[:abbr]]) if opts[value[:abbr]]
        if value[:value] && opts[key] && !value[:value].include?(opts[key])
          raise RandomTokenError.new(:invalid_option_value, opts)
        end
      end
      opts
    end

    # Generate seeds according to the :seed options
    def gen_seeds(opt)
      opt_seed = opt[:seed]
      default_opt = SEED_TYPES[:default]
      if opt_seed == nil || opt_seed.is_a?(Symbol) || opt_seed.is_a?(Fixnum)
        SEED_TYPES.each do |key, value|
          if ([key] + value[:abbr]).include?(opt_seed)
            opt.delete(:seed)
            opt = default_opt.merge(value).merge(opt)
            opt[:seed] = opt[:seed].map { |s| s.to_a }.flatten
            return seed_modifier(opt)
          end
        end
        raise RandomTokenError.new(:unknown_seed, opt_seed)
      elsif opt_seed.is_a?(Array)
        return seed_modifier(default_opt.merge(:case => :keep).merge(opt))
      elsif opt_seed.is_a?(Hash)
        seeds = opt_seed.to_a.map {|s| (s.first * s.last).split(//)}.flatten
        return seed_modifier(default_opt.
                             merge(opt).
                             merge(:seed => seeds,
                                   :support_case => false,
                                   :support_friendly => false ))
      else
        raise RandomTokenError.new(:unknown_seed, opt_seed)
      end
    end

    # Modify seeds according to the :case, :friendly and :mask options
    def seed_modifier(opt)
      if opt[:support_case]
        case_opt = opt[:case] || opt[:default_case]
        case case_opt
          when :up, :u
            cased_seed = opt[:seed].map { |s| s.upcase }
          when :down, :d, :lower, :l
            cased_seed = opt[:seed].map { |s| s.downcase }
          when :mixed, :m
            cased_seed = opt[:seed].map { |s| [s.upcase, s.downcase] }.flatten
          else
            # :keep, keep the seed case
            cased_seed = opt[:seed]
        end
        opt[:seed] = cased_seed.uniq
      else
        raise RandomTokenError.new(:not_support_case, opt) if opt[:case] != nil
      end
      if opt[:support_friendly]
        if opt[:friendly] || (opt[:friendly] == nil && opt[:mask])
          masked_seed = opt[:seed].dup
          mask = opt[:mask] || MASK
          mask.each { |m| masked_seed.delete(m) }
          opt[:seed] = masked_seed
        elsif opt[:friendly] == false && opt[:mask]
          raise RandomTokenError.new(:false_friendly_with_given_mask, opt)
        end
      else
        if opt[:friendly] == true || opt[:mask] != nil
          raise RandomTokenError.new(:not_support_friendly, opt)
        end
      end
      raise RandomTokenError.new(:mask_remove_all_seeds, opt) if opt[:seed] == []
      opt
    end
  end
end
