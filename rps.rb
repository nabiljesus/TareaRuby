##
# S'uperclase para los diferentes tipo de movimientos
# en el juego de piedra, papel o tijera
class Movement
  # Representaci'on para un tipo de movimiento
  attr_reader :rep

  # Inicializaci'on de representaci'on indefinida para Movimiento 
  def initialize
    @rep = "UNDEFINED"
  end

  # M'etodo para representar un movimiento como string, alias para rep
  def to_s
    self.rep
  end
end

##
# Clase que representa el movimiento +Roca+
#
class Rock < Movement 
  def initialize
    @rep = "✊"
  end

  def score(m)
    m.vs_rock
  end

  def vs_scissors
    [0,1]
  end

  def vs_rock
    [1,1]
  end

  def vs_paper
    [1,0]
  end
end

class Paper < Movement 
  def initialize
    @rep = "✋"
  end

  def score(m)
    oponent = m.vs_paper
  end

  def vs_rock
    [0,1]
  end

  def vs_paper
    [1,1]
  end

  def vs_scissors
    [1,0]
  end

end

class Scissors < Movement 
  def initialize
    @rep = "✀"
  end

  def score(m)
    oponent = m.vs_scissors
  end

  def vs_paper
    [0,1]
  end

  def vs_scissors
    [1,1]
  end

  def vs_rock
    [1,0]
  end
end


# Estrategias
class Strategy
  SEED = 42

  def initialize
    @rep = "UNDEFINED"
  end

  def next(m)
  end

  def to_s
    @rep + extras
  end

  def reset
  end

  def add_rep
    "<" + self.class.to_s + " Strategy"
  end

  def extras
    ">"
  end
end

class Biased < Strategy
  attr_accessor :randomizer, :moves

  def initialize(moves)
    @rep = add_rep
    self.randomizer = Random.new(SEED)
    
    if moves.empty?
      raise self.to_s + ' needs at least 1 move'
    else
      @moves = moves
    end
  end
  
  def next(m)
    randNumber = self.randomizer.rand(0...self.moves.map{|s| s[1]}.reduce(0,:+))
    # puts randNumber
    self.moves.each do |mov,limit|
      if randNumber < limit
        return eval(mov.to_s).new
      else
        randNumber -= limit
      end 
    end
  end

  def extras
    total = self.moves.map{|s| s[1]}.reduce(0,:+)
    strs = " | probabilities"
    @moves.each do |key,val|
      strs += " " + key.to_s + "=>" + Rational(val,total).to_s
    end
    strs + ">"
  end
end

class Uniform < Biased
  def initialize(moves)
    hash  = {}
    moves = moves.uniq
    moves.each { |movement| hash.store(movement,1)}
    super(hash)
  end
end


class Mirror < Strategy
  def initialize
    @rep       = add_rep
    @last_move = Rock.new
  end

  def next(m)
    previous   = @last_move
    unless m.nil?
      @last_move = m
    end
    previous
  end

  def reset
    @last_move = Rock.new
    self
  end
end

class Smart < Biased

  ININITSTATE = {:Rock => 1, :Paper => 0, :Scissors => 0}

  def initialize
    super ININITSTATE.clone
  end

  def next(m)
    move_made = super 

    # Almacenamos la jugada opuesta, en caso contrario no se hace nada
    case m 
    when Rock
      self.moves[:Paper] += 1
    when Scissors
      self.moves[:Rock] += 1
    when Paper
      self.moves[:Scissors] += 1
    end

    move_made
  end

  def reset
    self.randomizer = Random.new(SEED)
    self.moves      = ININITSTATE.clone
    self
  end
end



class Match
  attr_reader   :players,:strategies, :last_move,:times_played

  def initialize(playersHash)
    unless playersHash.is_a? Hash
      raise "Parameter given is not a hash"
    end

    unless playersHash.size.eql? 2
      raise "Match must have 2 players exactly inside hash"
    end

    unless playersHash.all? { |m,est| est.is_a? Strategy}
      raise "All values in hash must be strategies"
    end

    @players,@strategies = playersHash.keys,playersHash.values
    @results      = [0,0]
    @times_played = 0
    @last_moves   = nil
  end

  def rounds(n)
    n.times { play }
    @times_played += n
    results
  end

  def upto(n)
    while @results.max < n
      play
      @times_played += 1
    end
    results
  end

  def restart
    @last_move    = nil
    @results      = [0,0]
    @times_played = 0
    @strategies = @strategies.map { |strategy| strategy.reset }
  end

  def results
    { players[0]=>@results[0],
      players[1]=>@results[1],
      :Rounds   =>@times_played}
  end

  private 
  def play
    p1 = strategies[0].next(@last_move) # last_move puede ser o no nil
    p2 = strategies[1].next(p1)
    @last_move = p2
    res = p1.score(p2)
    puts p1.to_s + " vs " + p2.to_s + ": " + res.to_s
    @results[0] += res[0]
    @results[1] += res[1]
  end
end