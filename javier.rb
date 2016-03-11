require_relative 'bfs'

g = LCR.new({:where=>:right, :left=>[:wolf, :cabbage], :right=>[:sheep]})
g.each do |val|
  puts val
end