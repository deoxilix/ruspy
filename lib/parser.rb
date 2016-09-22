%w{
  tokenize
  ruspy
}.each{ |klas| require klas }

class String
  def is_integer?
    true if Integer(string) rescue false
  end

  def is_float?
    true if Float(string) rescue false
  end
end

class Parser
  attr_accessor :tokens
  def initialize(token_obj)
    @tokens = token_obj
  end

  def neucleate
    return "unexpected EOF" if @tokens.empty?

    if (token = tokens.pop) == "("
      enlist
    elsif token.is_integer?
      token.to_i
    elsif token.is_float?
      token.to_f
    else
      token.to_sym
  end

  def enlist
    list = []
    list << read until peek == ')'
    pop_token
    list
  end

  # private
  # def tokenize(exp)
  #   exp.scan /[()]|\w+|".*?"|'.*?'/
  # end
  #
  # def pop_token
  #   @tokens.shift
  # end
  #
  # def peek
  #   @tokens.first
  # end
end
