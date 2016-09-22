class Rusp
  attr_accessor :env
  def initialize(ext={})
    @defs = {}
    @env = {
      # :+ => -> fn a, b { a.send fn b }
      # :+ => -> fn, x, y { eval "n1 #{fn} n2" }
      :+ => -> _, x, y { x + y }
      :- => -> _, x, y { x - y }
      :* => -> _, x, y { x * y }
      :/ => -> _, x, y { x / y }
      :== => -> _, x, y { x == y }
      :!= => -> _, x, y { x != y }
      :> => -> _, x, y { x > y }
      :< => -> _, x, y { x < y }
      :>= => -> _, x, y { x >= y }
      :<= => -> _, x, y { x <= y }
      :define => -> _, var, val { self.env.merge[var] => val }
    }.merge(ext)
  end

  # #lisp
  # >>(begin(define r 10)(* pi (* r r)))
  # #tokenized
  # >>['(', 'begin', '(', 'define', 'r', '10', ')', '(', '*', 'pi', '(', '*', 'r', 'r', ')', ')', ')']
  # #parsed
  # ['begin', ['define', 'r', 10], ['*', 'pi', ['*', 'r', 'r']]]

  def evaluate(nesexp, eve = @env)
    nesexp.map!{ |micro| micro.is_a?(Array) ? evaluate(micro) : micro }
    if eve[nesexp.first].respond_to? :call
      eve[nesexp.first].(*nesexp)
    end
  end
end
