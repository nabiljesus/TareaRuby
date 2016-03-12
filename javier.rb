require_relative 'bfs'

g = LCR.new({:where=>:right, :left=>[:cabbage,:sheep,:wolf], :right=>[]})

#puts g.is_valid?({:where=>:left, :left=>[:cabbage,:sheep, :wolf], :right=>[]})

# g.each do |e,mensaje|
#     puts e
#     puts mensaje
# end

g.solve
