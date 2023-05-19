dados = [rand(1..6), rand(1..6), rand(1..6), rand(1..6), rand(1..6)]
puts dados.join(" ")
user_input = gets
mantener = user_input.split(" ")

nuevatirada = dados.map do |dado| 
    # if mantener.include?(dado.to_s)
    index = mantener.index(dado)
    if index
        mantener.delete(index)
        return dado
    else
        return rand(1..6)
    end
end

puts nuevatirada.join(" ") 