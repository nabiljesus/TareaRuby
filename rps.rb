class Movement
  attr_accessor :rep

  def initialize
    @rep = "UNDEFINED"
  end

  def vs_scissors
    0
  end

  def vs_rock
    0
  end

  def vs_paper
    0
  end

  def to_s
    self.rep
  end

  private 

  def oposite(n)
    if n == 1
      0
    else
      1
    end
  end
end

class Rock < Movement 
  def initialize
    @rep = "✊"
  end

  def score(m)
    oponent = m.vs_rock
    [oposite(oponent),oponent]
  end

  def vs_scissors
    1
  end
end

class Paper < Movement 
  def initialize
    @rep = "✋"
  end

  def score(m)
    oponent = m.vs_paper
    [oposite(oponent),oponent]
  end

  def vs_rock
    1
  end
end

class Scissors < Movement 
  def initialize
    @rep = "✀"
  end

  def score(m)
    oponent = m.vs_scissors
    [oposite(oponent),oponent]
  end

  def vs_paper
      1
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
    @rep
  end

  def reset
  end

  def add_rep
    self.class.to_s + " Strategy"
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
    puts randNumber
    self.moves.each do |mov,limit|
      if randNumber < limit
        return eval(mov.to_s).new
      else
        randNumber -= limit
      end 
    end
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
    @rep = add_rep
    @last_move= Rock.new
  end

  def next(m)
    previous   = @last_move
    @last_move = m
    previous
  end

  def reset
    @last_move = Rock.new
  end
end

class Smart < Biased

  ININITSTATE = {:Rock => 1, :Paper => 0, :Scissors => 0}

  def initialize
    super ININITSTATE.clone
  end

  def next(m)
    move_made = super 

    # Almacenamos la jugada opuest
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
  end
end

class Match
  def initialize(playersHash)
    unless playersHash.is_a? Hash
      raise "Parameter given is not a hash"
    end

    unless playersHash.size.eql? 2
      raise "Match must have 2 players exactly inside hash"
    end

    unless playersHash.all? { |m,est| est.is_a? Strategy}
      rais "All values in hash must be strategies"
    end

  end
end