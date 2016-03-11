##
# Mixin para recorrido Breadth-first Search
module BFS
  # Búsqueda BFS desde el nodo inicial aplicando el predicado en el 
  # contenido. Al encontrar el nodo lo retorna, si no lo encuentra se 
  # retorna nil.
  def find(start,&predicate)
    queue = []
    queue.push(start)
    visited = []
    
    while(!queue.empty?)
      node = queue.shift
      print "He visitado a: "
      puts node.value

      val=evalPred(node,&predicate)
      unless val.nil?
        return val
      end

      visited.push(node)

      node.each do |child|
        if !(visited.include? child)
          queue.push(child)
        end
      end
    end

    return nil
  end

  # Búsqueda BF desde el nodo start, aplicando el predicado en los 
  # nodos recorridos. Cuando algún predicado se cumpla, se retorna la lista
  # con el recorrido, en caso contrario se retorna objeto indefinido.
  def path(start,&predicate)
    queue = []
    queue.push([0,1,start])
    visited = []
    counter=1
    familyTree=Hash[]

    while(!queue.empty?)
      iddad,idnode,node = queue.shift
      print "Desencolo a: "
      puts node.value
      visited.push(node)
      familyTree[idnode]=[iddad,node]

      val=evalPred(node,&predicate)
      unless val.nil?
        return getPath(familyTree,idnode,[])
      end

      node.each do |child|
        if !(visited.include? child)
          print "Encolo a: "
          puts child.value
          counter+=1
          queue.push([idnode,counter,child])
        else
          print "Ya visito a: "
          puts child.value
        end
      end
    end

    return nil
  end

  # Recorrido aplicando la acción dada desde en nodo inicial start en BFS.
  def walk(start,&action)
    queue = []
    queue.push(start)
    visited = []

    while(!queue.empty?)
      node = queue.shift
      print "He visitado a: "
      puts node.value

      action.call(node)

      visited.push(node)

      node.each do |child|
        if !(visited.include? child)
          queue.push(child)
        end
      end
    end

    return visited
  end

  # Procedimiento para obtener el camino recorrido en la estructura
  def getPath(graph,counter,path=[])
    puts 'Entered'
    if counter==0
      puts 'llegue a 0'
      puts "THe path is:"
      #myp=[]
      #graph.each {|i,p| myp+=[[p[2].value,p[1].value,p[0]]]}
      #puts myp.to_s
      return path
    end
    iddad,node = graph[counter]
    if node.nil?
      return nil
    else
      path.unshift(node)
      puts '----'
      return getPath(graph,iddad,path)
    end
  end

  private :getPath 
  def evalPred(node,&p)
    if p.call(node)
      return node
    end   
  end
  private :evalPred 
end

##
# Árbol binario, en el cual un nodo vacío es equivalente a nil
class BinTree
  attr_accessor :value, # Valor del nodo
                :left,  # Hijo izquierdo
                :right  # Hijo derecho

  # Inicialización de un nodo, por defecto el hijo izquierdo y derecho no
  # están presentes 
  def initialize(v,l=nil,r=nil)
    @value = v
    @left = l
    @right = r
  end

  # Iterador para árbol binario. Se realiza una llamada del bloque 
  # proporcionado sobre el hijo izquierdo y derecho (solo si tiene sentido 
  # realizar la operación)
  def each(&b) #duda preguntar si es each(b) o asi
    #[b.call(self),self,right]
    unless left.nil?
      b.call(left)
    end
    unless right.nil?
      b.call(right)
    end
  end

  include BFS
end

##
# Representación de un grafo como un nodo junto a su lista de nodos adyacentes
class GraphNode
  attr_accessor :value,   # Valor alamacenado en el nodo
                :children # Arreglo de sucesores GraphNode
   
  # Inicialización de un nodo, la lista de adyacencia por defecto está vacía
  def initialize(v,c=[])
    @value=v
    @children=c
  end

  # Procedimiento que recibe un bloque, e itera sobre los hijos del nodo
  def each(&b) #Misma duda
    children.each do |child|
      unless child.nil?
        b.call(child)
      end
    end
  end

  include BFS
end

def LCR
  attr_reader :value
  def initialize(a)
    #
  end
  def each(p)
    #
  end
  def solve
    #
  end
end

