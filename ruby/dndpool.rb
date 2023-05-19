class Die 
    def initialize(values)
        @values = values
    end
    attr_reader :values

    def roll
        rand(values)
    end
end

def DicePool
    def initialize(dice)
        @dice = dice
    end
    attr_reader :dice
end

# puts Array((1..10))
die = Die.new(Array(1..10))
puts die.values

puts die.roll