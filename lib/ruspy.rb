require 'pry'

class Ruspy
  attr_accessor :env, :defs
  def initialize(ext_env={})
    @defs = {
      :pi => Math::PI
    }
    @env = {
      # :+ => -> fn a, b { a.send fn b },
      # :+ => -> fn, x, y { eval "n1 #{fn} n2" },
      :+ => -> fn, *args { args.inject(fn) rescue args.map(&:to_s).inject(fn) },
      :- => -> fn, *args { args.inject(fn) },
      :* => -> fn, *args { args.inject(fn) },
      :/ => -> fn, *args { args.inject(fn) },
      :== => -> fn, *args { args.inject(fn) },
      :!= => -> fn, *args { args.inject(fn) },
      :> => -> fn, *args { args.inject(fn) },
      :< => -> fn, *args { args.inject(fn) },
      :>= => -> fn, *args { args.inject(fn) },
      :<= => -> fn, *args { args.inject(fn) },
      :define => lambda {|_, var, val| self.defs[var] = val },
      :if => -> _, test, conseq, alt { test ? conseq : alt },
      # :lambda => -> _, *args { evaluate( exp, Hash[args.zip] ) },

      :car => -> _, *list { list.first },
      :cdr => -> _, *list { list[1..-1] }
    }.merge(ext_env)
  end



  def evaluate(nesexp, ext={})
    self.defs.merge!(ext) unless ext.empty?
    # binding.pry
    nesexp.map!{ |atom|
      atom.is_a?(Array) ? ( atom.first == :lambda ? procedure(*atom) : evaluate(atom) ) : micro(atom)
    }

    if self.env[nesexp.first].respond_to?(:call)
      self.env[nesexp.first].(*nesexp)
    # elsif nesexp.first.respond_to?(:Call)
    else
      nesexp.first.(*nesexp)
    end
  end

  def procedure(_, args, nesexp)
    lambda{ |_, *params| evaluate(nesexp, Hash[args.zip(params)]) }
  end

  def micro(atom)
    # self.defs.key?(atom) ? ( self.defs[atom].respond_to?(:call) ? self.defs[atom].() : self.defs[atom] ) : atom
    self.defs.key?(atom) ? self.defs[atom] : atom
  end
end
