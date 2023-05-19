# Statements ___________________________________________________________________

# Base class for all statement nodes
class Statement

  # Returns a string that will produce this same representation of code if it
  # gets parsed.
  def unparse()
    throw "#{self.class.name}.unparse() is not implemented!"
  end

  # Executes this statement on the given `state`, which must be a `Hash` mapping
  # variable names to values. May modify the given state. Returns a state, may
  # be the one given or a new one.
  def evaluate(state = {})
    throw "#{self.class.name}.evaluate() is not implemented!"
  end
end

# Representation of assignments, e.g. `identifier = expression;`.
class Assignment < Statement 
  def initialize(identifier, expression)
    @identifier = identifier
    @expression = expression
  end

  def evaluate(state)
    state[@identifier] = @expression.evaluate(state)
    state
  end

  attr_reader :identifier
  attr_reader :expression
end

# Representation of statements in sequence, e.g. `{ x = 1; y = 2; }`.
class Block < Statement
  def initialize(statements = [])
    @statements = statements
  end

  def evaluate(state)
    @statements.each do |statement|
      state = statement.evaluate(state)
    end
    state
  end

  attr_reader :statements
end

# Representation of conditional statements, e.g. `if (condition) bodyThen else bodyElse`.
class IfThenElse < Statement
  def initialize(condition, bodyThen, bodyElse = nil)
    @condition = condition
    @bodyThen = bodyThen
    @bodyElse = bodyElse
  end

  def evaluate(state)
    if(@condition.evaluate(state)) 
      @bodyThen.evaluate(state)
    else
      @bodyElse.evaluate(state)
    end
  end

  attr_reader :condition
  attr_reader :bodyThen
  attr_reader :bodyElse
end

# Representation of conditional statements, e.g. `while (condition) body`.
class WhileDo < Statement
  def initialize (condition, body)
    @condition = condition
    @body = body 
  end

  def evaluate(state)
    while(@condition.evaluate(state))
      state = @body.evaluate(state)
    end
    state
  end

  attr_reader :condition
  attr_reader :body
end

# Representation of print statements, e.g. `print (x * 2);`.
class PrintStmt < Statement
  def initialize(expression)
    @expression = expression
  end

  def evaluate(state)
    puts @expression.evaluate(state)
  end

  attr_reader :expression
end