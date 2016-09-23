class Tokenizer
  attr_accessor :tokens
  def initialize(expression)
    @tokens = expression.gsub('(', ' ( ').gsub(')', ' ) ').split(" ")
  end

  def empty?
    self.tokens.empty?
  end

  def pop
    self.tokens.shift
  end

  def peek
    self.tokens.first
  end
end
