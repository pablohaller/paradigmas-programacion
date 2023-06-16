require_relative 'test'
require_relative 'expressions'
require_relative 'statements'
require_relative 'parser'
require_relative 'functions'

puts "Welcome to Rubynterpreter."
puts "Finish your code with an empty line to process it."
puts ""
parser = Parser.new
input = []
state = {
          "hi" => FunctionHi.new(),
          "max" => FunctionMax.new(),
          "min" => FunctionMin.new(),
          # "abs" => FunctionAbs.new(),
          "abs" => FunctionDef.new('abs', ['x'], parser.parse_string("if (x < 0) { result = x * -1; } else { result = x; }")),
          "rand" => FunctionRand.new(),
          "pow" => FunctionPow.new(),
          "pi" => FunctionPi.new()
        }

Test.tests.map do |n|
  puts "Test:"
  puts n
  puts "\nResult:\n"
  ast = parser.parse_string(n)
  puts ast.unparse
  puts ast.evaluate(state)
  puts "\n--------------"
end

ARGF.each do |line|
  if (line.strip().empty?)
    code = input.join('\n')
    if (code.strip().empty?)
      puts "Exit"
      break
    else
      begin
        ast = parser.parse_string(code)
         # puts ast.unparse()
         puts ast.evaluate(state)
      rescue => error
        STDERR.puts "#{error.class}: #{error.message}"
      ensure
        input = []
      end
    end
  else
    input << line
  end
end

# if (x < 0) { result = x * -1; } else { result = x; }
