##
# Súper-clase para los diferentes tipo de movimientos
# en el juego de piedra, papel o tijera
class Movement
  # Representación para un tipo de movimiento
  attr_reader :rep

  # Inicialización de representación indefinida para Movimiento 
  def initialize
    @rep = "UNDEFINED"
  end

  # Función abstracta, recibe un movimiento y retorna el resultado del juego self vs m
  def score(m)
  end

  # Método para representar un movimiento como string, alias para rep
  def to_s
    self.rep
  end

  # Los métodos vs_scissors, vs_rock y vs_paper aunque no fueron definidos en el
  # enunciado no pueden ser privados ya que deben ser llamados por objetos 
  # de otra clase.

end

##
# Clase que representa el movimiento +Roca+
class Rock < Movement 
  def initialize
    @rep = "✊"
  end

  # Implementación con despacho doble
  def score(m)
    m.vs_rock
  end
  
  # Resultado de enfrentarse contra tijeras
  def vs_scissors
    [0,1]
  end

  # Resultado de enfrentarse contra la misma clase
  def vs_rock
    [1,1]
  end

  # Resultado de enfrentarse contra papel
  def vs_paper
    [1,0]
  end
end

##
# Clase que representa el movimiento +Papel+
class Paper < Movement 
  def initialize
    @rep = "✋"
  end

  # Implementación con despacho doble
  def score(m)
    oponent = m.vs_paper
  end
 

  # Análogo a movimientos en la clase Roca
  def vs_rock
    [0,1]
  end

  # Análogo a movimientos en la clase Roca
  def vs_paper
    [1,1]
  end

  # Análogo a movimientos en la clase Roca
  def vs_scissors
    [1,0]
  end

end

##
# Clase que representa el movimiento +Tijeras+
class Scissors < Movement 
  def initialize
    @rep = "✀"
  end

  # Implementación con despacho doble
  def score(m)
    oponent = m.vs_scissors
  end
 

  # Análogo a movimientos en la clase Roca
  def vs_paper
    [0,1]
  end

  # Análogo a movimientos en la clase Roca
  def vs_scissors
    [1,1]
  end

  # Análogo a movimientos en la clase Roca
  def vs_rock
    [1,0]
  end
end

##
# Súper-clase de los diferentes tipos de estrategias
class Strategy
  # Semilla para el generador de los números pseudo-aleatorios
  SEED = 42

  # Inicialización de clase, representación indefinida ya que esta es 
  # una estrategia genérica, no una implementación real
  def initialize
    @rep = "UNDEFINED"
  end

  # Método que realiza una jugada contra el movimiento m utilizando la 
  # estrategia actual y posiblemente utiliza a m para jugadas futuras
  def next(m)
  end

  # Representación genérica para una estrategia
  def to_s
    @rep + extras
  end

  # Método abstracto para reiniciar la estrategia dada
  def reset
  end

  # Agrega el nombre de la clase a la representación como string in caso de ser
  # necesario
  private 

  def add_rep
    "<" + self.class.to_s + " Strategy"
  end

  # Finalización de representaciones en string que la requieran
  def extras
    ">"
  end
end

##
# Estrategia que recibe posibles movimientos y sus probabilidades
class Biased < Strategy
  attr_accessor :randomizer, :moves

  # Inicialización de estrategia que recibe un hash con movimientos posiblemente
  # del tipo symbols ie. :Rock, :Paper, :Scissors como claves y un entero
  # como valor de tal forma que val/tot_val = probabilidad que posee.
  def initialize(moves)
    @rep = add_rep
    self.randomizer = Random.new(SEED)
    
    if moves.empty?
      raise self.to_s + ' needs at least 1 move'
    else
      @moves = moves
    end
  end
  
  # Procedimiento que indica el movimiento a realizar luego de m, esta
  # implementación ignora que jugó el oponente, solo utiliza resultados
  # al azar dentro de las proporciones ofrecidas
  def next(m)
    randNumber = self.randomizer.rand(0...self.moves.map{|s| s[1]}.reduce(0,:+))
    
    self.moves.each do |mov,limit|
      if randNumber < limit
        return eval(mov.to_s).new
      else
        randNumber -= limit
      end 
    end
  end

  # Información interna para ser utilizada por to_s
  def extras
    total = self.moves.map{|s| s[1]}.reduce(0,:+)
    strs = " | probabilities"
    @moves.each do |key,val|
      strs += " " + key.to_s + "=>" + Rational(val,total).to_s
    end
    strs + ">"
  end
end

##
# Especialización de Biased, en donde las probabilidades de jugadas están 
# distribuidas uniformemente
class Uniform < Biased
  # Inicialización que recibe los diferentes movimientos como una lista de
  # símbolos (:Rock, :Paper, :Scissors) y adapta los valores a Biased
  def initialize(moves)
    hash  = {}
    moves = moves.uniq
    moves.each { |movement| hash.store(movement,1)}
    super(hash)
  end
end

##
# Estrategia en la que siempre se intenta repetir la jugada anterior del oponente
class Mirror < Strategy

  # Inicialización con ´movimiento anterior´ default +Roca+
  def initialize
    @rep       = add_rep
    @last_move = Rock.new
  end

  # Se realiza la jugada anterior del oponente y se actualiza la esta 
  # en caso de tener algo de sentido
  def next(m)
    previous   = @last_move
    unless m.nil?
      @last_move = m
    end
    previous
  end

  # Reinicio del último movimiento al estado inicial +Roca+
  def reset
    @last_move = Rock.new
    self
  end
end

##
# Estrategia inteligente, en la que la probabilidad de un movimiento viene
# condicionada por las jugadas del oponente
class Smart < Biased
  # Estado inicial de la estrategia
  ININITSTATE = {:Rock => 1, :Paper => 0, :Scissors => 0}

  # Se realiza una copia del estado inicial
  def initialize
    super ININITSTATE.clone
  end

  # Se realiza una jugada similar a la de Biased con el estado actual de la
  # estrategia como probabilidades
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

  # Se olvidan las jugadas del oponente y se reinicia el generador de 
  # números al azar
  def reset
    self.randomizer = Random.new(SEED)
    self.moves      = ININITSTATE.clone
    self
  end
end

##
# Representación de un juego, en donde se conoce el número de veces que se ha
# jugado, el último movimiento realizado, los jugadores y sus respectivas
# estrategias
class Match
  # Inicialización, se debe recibir un hash con las claves de los 2 jugadores 
  # y sus estrategias, en caso de este parámetro no cumpla con estas
  # especificaciones se genera una excepción
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

  # El jugador 1 y 2 realizan n partidas y se retornan los resultados
  def rounds(n)
    n.times { play }
    @times_played += n
    results
  end

  # El jugador 1 y 2 realizan partidas hasta que alguno obtenga n victorias
  def upto(n)
    while @results.max < n
      play
      @times_played += 1
    end
    results
  end

  # Reinicio del último movimiento, los resultados, la cantidad de veces jugadas
  # y las estrategias se llevan a su estado inicial
  def restart
    @last_move    = nil
    @results      = [0,0]
    @times_played = 0
    @strategies   = @strategies.map { |strategy| strategy.reset }
  end

  private
  # Representación de los resultados
  def results
    { @players[0]=>@results[0],
      @players[1]=>@results[1],
      :Rounds    =>@times_played}
  end

  # Procedimiento para realizar una jugada
  def play
    # El jugador 1 realiza un movimiento (posiblemente el primero de la partida)
    p1 = @strategies[0].next(@last_move) # last_move puede ser o no nil
    # El jugador 2 realiza otro movimiento y recibe la jugada de j1
    p2 = @strategies[1].next(p1)
    # Se actualiza el último movimiento
    @last_move = p2
    # Se realiza la jugada y se actualizan los resultados
    res = p1.score(p2)
    @results[0] += res[0]
    @results[1] += res[1]
  end
end