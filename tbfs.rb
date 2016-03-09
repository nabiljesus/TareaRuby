require_relative 'bfs'

# load('rps.rb')
# treel  = BinTree.new(11)
# treer = BinTree.new(15)
# tree       = BinTree.new(10,treel,treer)
# puts tree.left.value
# puts tree.right.value
# puts tree.value
# puts 'trululu'

# tree.each { |value| puts "#{value}"}

puts "graph shit"

x=[2,3,4,5]
y=x.collect{|v| GraphNode.new(v)}
graphe=GraphNode.new(1)
y.push(graphe)
y.push(GraphNode.new(10000))
graph=GraphNode.new(1,y)

graph.each { |value| print "#{value}\n"}


