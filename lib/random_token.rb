require "random_token/random_token_error"

module RandomToken
  class << self
    VERSION = '1.0.0.0'

    NUMBERS = ('0'..'9')
    ALPHABETS = ('A'..'Z')
    MASK = ['1', 'I', 'l', 'i', '0', 'O', 'o', 'Q', 'D',
            'C', 'c', 'G', '9', '6', 'U', 'u', 'V', 'v',
            'E', 'F', 'M', 'N', '8', 'B']

    DEFAULT_OPT = {
      :seed => nil,
      :friendly => false,
      :case => :mixed
    }

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

    def gen(arg, options = {})
      if arg.class.name == 'Fixnum'
        get(arg, options)
      elsif arg.class.name == 'String'
        strf(arg, options)
      else
        raise RandomTokenError.new(:invalid_gen_arg, arg)
      end
    end

    def genf(arg, options = {})
      gen(arg, { :friendly => true }.merge(option))
    end

    def get(length, options = {})
      seeds = gen_seeds(options)[:seed]
      token = (0...length).map{ seeds[rand(seeds.length)] }.join
    end

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
            result << self.get((length == "") ? 1 : length.to_i, STRF_ARG_MAP[x].merge(options))
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

    def default_mask
      return MASK
    end

    private

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

