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

# Incompleta, podría ser subclase de Biased con prob 1/tot para cada 1
class Uniform < Strategy
  attr_accessor :randomizer

  def initialize(moves)
    @rep = add_rep
    @randomizer = Random.new(SEED)
    
    if moves.empty?
      raise 'Uniform strategy needs at least 1 move'
    else
      @moves = moves.uniq
    end
  end
  
  # Creo que esta dist no es uniforme, generar un float entre 0 y 1
  def next(m)
    eval(@moves[randomizer.rand(@moves.size)].to_s).new
  end
end

# 
class Biased < Strategy
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