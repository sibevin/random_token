require "random_token/random_token_error"

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

  # The directives used in the {RandomToken.strf} method.
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
    # The major method to generate a random token. It would call {RandomToken.get} or {RandomToken.strf} according to the given arg.
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
    # @see RandomToken.get
    # @see RandomToken.strf
    def gen(arg, options = {})
      if arg.class.name == 'Fixnum'
        get(arg, options)
      elsif arg.class.name == 'String'
        strf(arg, options)
      else
        raise RandomTokenError.new(:invalid_gen_arg, arg)
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

    # To generate a random token with a given length.
    # @param length [Fixnum]
    #   The token length.
    # @param options (see RandomToken.gen)
    # @return (see RandomToken.gen)
    # @raise (see RandomToken.gen)
    def get(length, options = {})
      seeds = gen_seeds(options)[:seed]
      token = (0...length).map{ seeds[rand(seeds.length)] }.join
    end

    # To generate a random token with a string format. Please see {file:README.rdoc} to get more detail usage and examples
    # @param pattern [String]
    #   The string format pattern.
    # @param options (see RandomToken.gen)
    # @return (see RandomToken.gen)
    # @raise (see RandomToken.gen)
    def strf(pattern, options = {})
      in_arg = false
      result = ''
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
            result << self.get((length == "") ? 1 : length.to_i,
                               STRF_ARG_MAP[x].merge(options))
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

    def count(arg, options = {})
      if arg.is_a?(Fixnum)
        # TODO
      elsif arg.is_a?(String)
        # TODO
      end
    end

    private

    # To generate seeds according to the :seed options
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
        return seed_modifier(default_opt.merge(opt).merge(:seed => seeds,
                                                          :support_case => false,
                                                          :support_friendly => false ))
      else
        raise RandomTokenError.new(:unknown_seed, opt_seed)
      end
    end

    # To modify seeds according to the :case, :friendly and :mask options
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
      opt
    end
  end
end

