class Tokenizer
  attr_accessor :tokens
  def initialize(expression)
    @tokens = expression.scan /[()]|\w+|".*?"|'.*?'/
  end

  def empty?
    tokens.empty?
  end

  def pop
    tokens.shift
  end

  def peek
    tokens.first
  end
end
