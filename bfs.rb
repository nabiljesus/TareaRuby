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
    puts
    while(!queue.empty?)
      node = queue.shift
      print "He visitado a: "
      puts node.value[0].value

      val=evalPred(node,&predicate)
      unless val.nil?
        return val
      end

      visited.push(node)

      puts "--Mis hijos son:"
      node.each do |child|
        if !(visited.include? child)
          print "----"
          puts child.value[0].value
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

##
# Clase que modela acertijos de configuración como el de +Fox, Goose and Bag 
# of Beans+ 
class LCR
  # Lector de la configuración actual del acertijo
  attr_reader :value
  # Inicialización del juego, se recibe el estado inicial de la clase

  def initialize(value=Hash[:where=>:left,:left=>[:cabbage,:sheep,:wolf],:right=>[]])
  #   begin
  #     hkeys=value.keys
  #     tsiz=value[:left].length+value[:right].length
  #   rescue
  #     #handle the error here
  #   ensure
  #     !(value.nil?)
  #   end
  #   ensure
  #     hkeys.all? {|key| key.class.name=="Symbol"}
  #   end
  #   #ensure
  #   #  hkeys.include? :right && hkeys.include? :left && hkeys.include? :where   
  #   #end
  #   ensure
  #     [:right,:left].include? value[:where]
  #   end
  #   ensure
  #     tsiz==2 || tsiz == 3
  #   end
  # else
    myH={:where=>value[:where],:left=>value[:left].sort,:right=>value[:right].sort}
    @value=myH
  end

  # Dado un bloque b, se itera sobre los hijos del estado actual
  def each(&b)
    val_clone = self.value.clone
    
    # Se generan los dos casos para mover el bote a la derecha o a la izquierda
    if self.value[:where].eql? :left
      val_clone[:where]=:right
    else
      val_clone[:where]=:left
    end

    message = "Moviendo bote a la " + val_clone[:where].to_s
    b.call(val_clone,message)
    
    # Si no hay elementos en el bote se pueden subir los de esa orilla,
    # si alguno ya se encontraba en el transporte se puede bajar 
    if self.value[:left].size + self.value[:right].size == 3
      self.value[self.value[:where]].each do |elem|
        val_clone                      = self.value.clone
        val_clone[self.value[:where]] -= [elem]
        val_clone[self.value[:where]]  = val_clone[self.value[:where]].sort
        
        message = "Subiendo a " + elem.to_s + " al bote"
        b.call(val_clone,message)
      end
    else
      #REVISAR ESTO ACA
      val_clone = self.value.clone
      val_clone[self.value[:where]]=(val_clone[self.value[:where]].unshift missing_elem)
      val_clone[self.value[:where]]=val_clone[self.value[:where]].sort
        
      message = "Dejando en la orilla " + val_clone[:where].to_s + " al " + missing_elem.to_s
      b.call(val_clone,message)
    end

    ## Cualquier animal que se encuentre en la 
    ##val_clone = self.value.clone
    

  end

  # Procedimiento que resuelve el problema de búsqueda imprimiendo las acciones
  # que se realizaron
  def solve
    ##Chequear que sea un estado inicial valido o arrojar exepcion

    #Agregar valores iniciales
    iState=@value
    inode=GraphNode.new([self,"Everyone in x shore"])
    myGraph=inode
    queue=[inode]
    actValue=@value
    visited=[]
    solution=getSolution(@value)
    #Construyendo el árbol de estados hasta crear una solución posible 'solution'
    while (!queue.empty?)
      node=queue.shift
      actValue=node.value[0].value
      puts "===Papa: "
      puts node
      puts actValue
      visited.unshift(actValue) #revisar
      actLCR=node.value[0]
      #puts actValue
      cChildren=[]
      actLCR.each do |maybC,msg|
        unless maybC.nil?
          if (is_valid?(maybC) && !(visited.include? maybC))
            puts "--reviso hijo--"
            puts maybC
            childLCR=LCR.new(maybC)
            childNode=GraphNode.new([childLCR,msg])
            node.children.push(childNode)
            unless !childNode.nil?
              puts "CHILD NODE NULLLLL" #obviar estas 4 lineas
              puts childNode.value
            end
            queue.push(childNode) #revisar
            visited.push(maybC)
          end
        end
      end
    end

    #Recorriendo el Grafo generado, myGraph, en busqueda de la solucion deseada ((myGraph.path(myGraph,&proc ])))
    myPath = []
    checkIfSolution=proc {|node| node.value[0].value==solution}
    myPath = myGraph.path(myGraph,&checkIfSolution)
    x=proc {|node| node=='potato'}
    
    puts "La busqueda:"
    myGraph.find(myGraph,&x)

    print "Is it null? : "
    puts myPath.nil?
    puts "\n\nDa answer isssssssssssssssssss\n\n"
    myPath.each {|val| puts "En estado: #{val.value[0].value} == Yo he #{val.value[1]}"}
    
  end

  # private

  ##Dado un estado con un symbol en el bote, devuelve dicho symbol.
  def missing_elem
    [:wolf,:cabbage,:sheep].each do |e|
      unless ((self.value[:left].include? e) || (self.value[:left].include? e))
        return e
      end
    end
  end

  

  ##Dado un estado, devuelve true si es valido, false en caso contrario
  def is_valid?(state)

    def dangerous?(list)
      # puts list
      # puts ((list==[:wolf,:sheep]) or (list==[:cabbage,:sheep]))
      return ((list==[:sheep,:wolf]) or (list==[:cabbage,:sheep]))
    end

    unsafe = [state[:left],state[:right]].any? { |l| dangerous?(l)}

    not unsafe
  end

  ##Dado un estado inicial, devuelve la solución deseada
  def getSolution(iState)
    if (iState[:left].size + iState[:right].size < 3) ||
       (iState[:left].size==3 && iState[:right].size !=0) ||
       (iState[:right].size==3 && iState[:left].size !=0)
      #Arrojar exeption?
      return nil
    else 
      if iState[:left].size==3
        return {:where=>:right,:left=>[],:right=>[:cabbage,:sheep,:wolf]}
      else  
        return {:where=>:left,:left=>[:cabbage,:sheep,:wolf],:right=>[]}
      end
    end
  end

end
