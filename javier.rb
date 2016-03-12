require_relative 'bfs'

g = LCR.new({:where=>:left, :left=>[:sheep,:wolf], :right=>[]})

puts g.is_valid?({:where=>:left, :left=>[:wolf], :right=>[:cabbage,:sheep]})

# g.each do |e,mensaje|
#     puts e
#     puts mensaje
# end

# g.solve