require_relative 'bfs'


tree0  = BinTree.new(0)
tree2  = BinTree.new(2)
tree1  = BinTree.new(1,tree0,tree2)
tree5  = BinTree.new(5)
tree4  = BinTree.new(4,nil,tree5)
tree6  = BinTree.new(6,tree4)
tree3  = BinTree.new(3,tree1,tree6)
tree10  = BinTree.new(10)
tree11  = BinTree.new(11,tree10)
tree8  = BinTree.new(8)
tree9  = BinTree.new(9,tree8,tree11)
tree14  = BinTree.new(14)
tree15  = BinTree.new(15,tree14)
tree13  = BinTree.new(13,nil,tree15)
tree12  = BinTree.new(12,tree9,tree13)
tree       = BinTree.new(7,tree3,tree12)
tree13.left = tree
#treel.left=tree
#puts tree.left.value
#puts tree.right.value
#puts tree.value
puts 'trululu'

#tree.each { |value| print "#{value.value}--"}
#tree.left.each { |value| print "#{value.value}--"}

#puts 'hia\n'

# x=proc {|x| x.value>13}


# y=tree.path(tree,&x)
# puts y.nil?
# puts "FUCK THIS SHIT"
# if  !(y.nil?)
# 	y.each {|v| puts v.value}
# 	puts "\ngraph shit"
# else
# 	puts "Null muthafucka."

# end

graphG=GraphNode.new('G')
graphD=GraphNode.new('D',[graphG])
graphC=GraphNode.new('C',[graphG,graphC])
graphB=GraphNode.new('B',[graphD])
graphA=GraphNode.new('A',[graphB,graphC])
graphS=GraphNode.new('S',[graphA,graphG])
graphG.children=[graphS]

action = proc {|node| node.value=='W'}
y=graphS.find(graphS,&action)
puts "FUCK THIS SHIT"
puts y.nil?
#y.each {|v| puts v.value}
unless y.nil?
	puts y.value
end
puts "\ngraph shit"

# x=[2,3,4,5]
# y=x.collect{|v| GraphNode.new(v)}
# graphe=GraphNode.new(1)
# y.push(graphe)
# y.push(GraphNode.new(10000))
# graph=GraphNode.new(1,y)

# w=graph.each { |value| print "#{value}\n"}
# puts 'meeeh'
# puts w

#puts "find"
#isodd = lambda { |i| i % 2 == 1 }
#graph.find(graph,isodd)
