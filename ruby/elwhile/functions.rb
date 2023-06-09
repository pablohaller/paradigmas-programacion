
# Representation of FunctionCall`.
class FunctionCall < Expression
  def initialize(fun_name, arguments = [])
    @fun_name = fun_name
    @arguments = arguments
  end

  def unparse()
    "#{@fun_name}(#{ @arguments.map{ | argument | argument.unparse() }.join(",") })"
  end

  def evaluate(state = {})
    state[@fun_name].evaluate_call(@arguments.map{ | argument | argument.evaluate(state) })
  end

  attr_reader :fun_name
  attr_reader :arguments
end

class FunctionImpl
  def initialize(name)
    @name = name
  end
  def evaluate_call(args)
    throw "#{self.class.name}.evaluate_call() is not implemented!"
  end
end

class FunctionHi < FunctionImpl
  def initialize()
    super('hi')
  end
  def evaluate_call(args)
    puts "Hi"
  end
end

class FunctionMax < FunctionImpl
  def initialize()
    super('max')
  end
  def evaluate_call(args)
    args.max
  end
end

class FunctionMin < FunctionImpl
  def initialize()
    super('min')
  end
  def evaluate_call(args)
    args.min
  end
end

class FunctionAbs < FunctionImpl
  def initialize()
    super('abs')
  end
  def evaluate_call(args)
    args[0].abs
  end
end

class FunctionRand < FunctionImpl
  def initialize()
    super('rand')
  end
  def evaluate_call(args)
    rand(0..1)
  end
end


class FunctionPow < FunctionImpl
  def initialize()
    super('pow')
  end
  def evaluate_call(args)
    args[0] ** args[1]
  end
end

class FunctionPi < FunctionImpl
  def initialize()
    super('pi')
  end
  def evaluate_call(args)
    Math::PI
  end
end
