require_relative 'bfs'

g = LCR.new({:where=>:left, :left=>[:sheep,:wolf], :right=>[]})

g.each do |e,mensaje|
    puts e
    puts mensaje
end

# g.solve