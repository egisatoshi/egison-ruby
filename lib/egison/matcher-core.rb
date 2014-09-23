require 'egison/core'
require 'egison/lazyarray'

class Class
  include PatternMatch::Matchable

  def unnil(val)
    if val.empty?
      [[]]
    else
      []
    end
  end

  def uncons(val)
    fail NotImplementedError, "need to define `#{__method__}'"
  end

  def uncons_stream(val, &block)
    fail NotImplementedError, "need to define `#{__method__}'"
  end

  private

  def test_conv_lazy_array(val)
    fail PatternMatch::PatternNotMatch unless val.respond_to?(:each)
    Egison::LazyArray.new(val)
  end
end

module Egison
  extend self

  class << Struct
    def unnil(val)
      [[]]
    end
    
    def uncons(val)
      val2 = val.clone
      x = val2.shift
      [[x, val2]]
    end

    def unjoin(val)
      val2 = val.clone
      xs = []
      ys = val2.clone
      rets = [[xs, ys]]
      until val2.empty?
        x = val2.shift
        ys = val2.clone
        xs += [x]
        rets += [[xs, ys]]
      end
      rets
    end
  end

  class List
  end

  class << List
    def uncons(val)
      val2 = val.clone
      x = val2.shift
      [[x, val2]]
    end

    def uncons_stream(val, &block)
      unless val.is_a?(Array) || val.is_a?(Egison::LazyArray)
        val = test_conv_lazy_array(val)
      end
      val2 = val.clone
      x = val2.shift
      block.([x, val2])
    end

    def unjoin(val)
      val2 = val.clone
      xs = []
      ys = val2.clone
      rets = [[xs, ys]]
      until val2.empty?
        x = val2.shift
        ys = val2.clone
        xs += [x]
        rets += [[xs, ys]]
      end
      rets
    end

    def unjoin_stream(val, &block)
      unless val.is_a?(Array) || val.is_a?(Egison::LazyArray)
        val = test_conv_lazy_array(val)
      end
      val2 = val.clone
      xs = []
      ys = val2.clone
      block.([xs, ys])
      until val2.empty?
        x = val2.shift
        ys = val2.clone
        xs += [x]
        block.([xs, ys])
      end
    end
  end
end
