require 'lib/parser'
require 'lib/ruspy'

ruspy = Ruspy.new

loop do
  print "lispy> "; STDOUT.flush; line = gets.strip
  break if line.empty? || line == "exit"

  begin
    expression = Parser.new(Tokenize.new(line)).neucleate
    print "lispy> "; STDOUT.flush; p ruspy.evaluate(expression)

  rescue Exception => error
    # ANSI escaped red
    puts "\e[31m"
    puts "on #{error.backtrace.pop}: #{error.message}"
    puts error.backtrace.map { |line| "\tfrom:#{line} " }
    # Clear ANSI escapes
    print "\e[0m"
  end
end
