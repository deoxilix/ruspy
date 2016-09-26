%w{
  tokenizer
  ruspy
}.each{ |klas| require_relative klas }

class String
  def is_integer?
    true if Integer(self) rescue false
  end

  def is_float?
    true if Float(self) rescue false
  end
end

class Parser
  attr_accessor :tokens
  def initialize(token_obj)
    @tokens = token_obj
  end

  def atomize
    token = self.tokens.pop
    if token == "("
      list = []
      until self.tokens.peek == ')' do
        list << atomize
      end
      self.tokens.pop
      list
    elsif token == ')'
      raise 'lisp::Syntax Error'
    else
      convert(token)
    end
  end

  def convert(token)
    if token.is_integer?
      token.to_i
    elsif token.is_float?
      token.to_f
    else
      token.to_sym
    end
  end
end
