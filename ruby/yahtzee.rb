# dados = [rand(1..6), rand(1..6), rand(1..6), rand(1..6), rand(1..6)]
# puts dados.join(" ")
# user_input = gets
# mantener = user_input.split(" ")

# nuevatirada = dados.map do |dado|
#     # if mantener.include?(dado.to_s)
#     index = mantener.index(dado)
#     if index
#         mantener.delete(index)
#         return dado
#     else
#         return rand(1..6)
#     end
# end

# puts nuevatirada.join(" ")

class Die
    def initialize(values)
        @values = values
    end

    def rollUntil(min)
        roll = rand(@values)
        puts roll
        while (roll <= min)
            roll = rand(@values)
            puts roll
        end
    end

    attr_reader :values
end

mydie = Die.new((1..6))
mydie.rollUntil(3)
