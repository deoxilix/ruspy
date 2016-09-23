class Ruspy
  attr_accessor :env, :defs
  def initialize(ext_env={})
    @defs = {}
    @env = {
      # :+ => -> fn a, b { a.send fn b },
      # :+ => -> fn, x, y { eval "n1 #{fn} n2" },
      :+ => -> _, x, y { x + y },
      :- => -> _, x, y { x - y },
      :* => -> _, x, y { x * y },
      :/ => -> _, x, y { x / y },
      :== => -> _, x, y { x == y },
      :!= => -> _, x, y { x != y },
      :> => -> _, x, y { x > y },
      :< => -> _, x, y { x < y },
      :>= => -> _, x, y { x >= y },
      :<= => -> _, x, y { x <= y },
      :define => lambda {|_, var, val| self.defs[var] = val }
    }.merge(ext_env)
  end

  def evaluate(nesexp)
    nesexp.map!{ |atom| atom.is_a?(Array) ? evaluate(atom) : micro(atom) }
    # if nesexp.first == :define
    if self.env[nesexp.first].respond_to?(:call)
      self.env[nesexp.first].(*nesexp)
    end
  end

  def micro(atom)
    if self.defs.key?(atom)
     self.defs[atom]
    else
     atom
    end
  end
end
