require_relative 'rps'

m = Match.new( { :Deepthought => Smart.new, :Multivac => m = Biased.new( { :Rock => 1, :Scissors => 1, :Paper => 2 } ) })
m.rounds(10)
m.rounds(10)
r = m.upto(100)
puts r
puts Uniform.new( [:Rock,:Scissors,:Paper] ) 
puts Smart.new
puts Biased.new( { :Rock => 1, :Scissors => 1, :Paper => 2 } )