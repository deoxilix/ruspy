require_relative 'lib/parser'
require_relative 'lib/ruspy'
require_relative 'lib/tokenizer'
require 'pry'

ruspy = Ruspy.new

loop do
  print "lispy> "; STDOUT.flush; lisp = gets.strip
  break if lisp.empty? || lisp == "exit"

  begin
    expression = Parser.new(Tokenizer.new(lisp)).atomize
    print "lispy> "; STDOUT.flush; puts ruspy.evaluate(expression)

  rescue Exception => error
    puts "\e[31m"
    puts "on #{error.backtrace.pop}: #{error.message}"
    puts error.backtrace.map { |line| "\tfrom:#{line} " }
    print "\e[0m"
  end
end
