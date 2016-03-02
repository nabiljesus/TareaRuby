class Movement 
  def initialize
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
  end

  def score(m)
    oponent = m.vs_rock
    [oposite(oponent),oponent]
  end

  def vs_scissors
    1
  end

  def to_s
    "✊" 
  end
end

class Paper < Movement 
  def initialize    
  end

  def score(m)
    oponent = m.vs_paper
    [oposite(oponent),oponent]
  end

  def vs_rock
    1
  end

  def to_s
    "✋"
  end
end

class Scissors < Movement 
  def initialize
  end

  def score(m)
    oponent = m.vs_scissors
    [oposite(oponent),oponent]
  end

  def vs_paper
      1
  end

  def to_s
      "✀"
  end
end