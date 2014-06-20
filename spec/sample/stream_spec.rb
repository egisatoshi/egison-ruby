require 'spec_helper'
require 'egison'
require 'prime'

include Egison

def twin_primes
  match_stream(Prime) {
    with(List.(*_, _x, __("x + 2"), *_)) {
      [x, x + 2]
    }
  }
end

def nats
  (1..Float::INFINITY)
end

describe "sample" do
  describe "stream.rb" do
    it %q{match_stream(1..5){ with(List.(*_, _x, *_, _y, *_)) { [x, y] } }.to_a } do
      expect(match_stream(1..5){ with(List.(*_, _x, *_, _y, *_)) { [x, y] } }.to_a).to eq \
        [[1, 2], [1, 3], [2, 3], [1, 4], [2, 4], [3, 4], [1, 5], [2, 5], [3, 5], [4, 5]]
    end

    it %q{twin_primes.take(10)} do
      expect(twin_primes.take(10)).to eq \
        [[3, 5], [5, 7], [11, 13], [17, 19], [29, 31], [41, 43], [59, 61], [71, 73], [101, 103], [107, 109]]
    end

    # (take 10 (match-all nats (multiset integer) [<cons $m <cons $n _>> [m n]]))
    it %q{match_stream(nats){ with(Multiset.(_m, _n, *_)) { [m, n] } }.take(10)} do
      expect(match_stream(nats){ with(Multiset.(_m, _n, *_)) { [m, n] } }.take(10)).to eq \
        [[1, 2], [1, 3], [2, 1], [1, 4], [2, 3], [3, 1], [1, 5], [2, 4], [3, 2], [4, 1]]
    end

    # (take 20 (match-all nats (multiset integer) [<cons $m <cons $n _>> [m n]]))
    it %q{match_stream(nats){ with(Multiset.(_m, _n, *_)) { [m, n] } }.take(20)} do
      expect(match_stream(nats){ with(Multiset.(_m, _n, *_)) { [m, n] } }.take(20)).to eq \
        [[1, 2], [1, 3], [2, 1], [1, 4], [2, 3], [3, 1], [1, 5], [2, 4], [3, 2], [4, 1],
         [1, 6], [2, 5], [3, 4], [4, 2], [5, 1], [1, 7], [2, 6], [3, 5], [4, 3], [5, 2]]
    end

    # (take 10 (match-all nats (set integer) [<cons $m <cons $n _>> [m n]]))
    it %q{match_stream(nats){ with(Set.(_m, _n, *_)) { [m, n] } }.take(10)} do
      expect(match_stream(nats){ with(Set.(_m, _n, *_)) { [m, n] } }.take(10)).to eq \
        [[1, 1], [1, 2], [2, 1], [1, 3], [2, 2], [3, 1], [1, 4], [2, 3], [3, 2], [4, 1]]
    end

    # (take 20 (match-all nats (set integer) [<cons $m <cons $n _>> [m n]]))
    it %q{match_stream(nats){ with(Set.(_m, _n, *_)) { [m, n] } }.take(20)} do
      expect(match_stream(nats){ with(Set.(_m, _n, *_)) { [m, n] } }.take(20)).to eq \
        [[1, 1], [1, 2], [2, 1], [1, 3], [2, 2], [3, 1], [1, 4], [2, 3], [3, 2], [4, 1],
         [1, 5], [2, 4], [3, 3], [4, 2], [5, 1], [1, 6], [2, 5], [3, 4], [4, 3], [5, 2]]
    end

    # assign to a variable, execute twice (or more), then obtain the same results. (for twin-primes)
    it %q{assign to a variable, execute twice (or more), then obtain the same results. (for twin-primes)} do
      tp = twin_primes
      tp.take(10) # discard
      expect(tp.take(10)).to eq \
        [[3, 5], [5, 7], [11, 13], [17, 19], [29, 31], [41, 43], [59, 61], [71, 73], [101, 103], [107, 109]]
    end
  end
end
