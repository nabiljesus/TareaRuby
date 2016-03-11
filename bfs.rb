module BFS
        def find(start,&predicate)

            queue = []
            queue.push(start)
            visited = []

            while(!queue.empty?)
              node = queue.shift
              puts node.value
              visited.push(node)

              val=evalPred(node,&predicate)
              unless val.nil?
                return val
              end

              node.each do |child|
                if !(visited.include? child)
                  queue.push(child)
                end
              end
            end

            return nil
        end

        def path(start,&predicate)

            queue = []
            queue.push([0,start])
            visited = []
            ograph = Hash[]
            dadcounter=0
            oldnode=start
            counter=0

            while(!queue.empty?)
              dadcounter,node = queue.shift
              ograph[counter]=[dadcounter,node,oldnode]
              counter+=1
              #puts node.value
              visited.push(node)
              puts "GET IT"
              puts node.value
              
              val=evalPred(node,&predicate)
              unless val.nil?
                puts "DA ANSWER"
                puts node.value
                puts counter
                myp=[]
                ograph.each {|i,p| myp+=["#{i}=>[Son: #{p[2].value}, Dad: #{p[1].value},dcount: #{p[0]}]"]}
                puts myp.join(", ")
                return getPath(ograph,counter,[node])
              end

              #oldcounter=counter
              oldnode=node

              node.each do |child|
                if !(visited.include? child)
                  queue.push([counter,child,oldnode])
                  #ograph[counter]=[oldcounter,node,child]
                  #puts "da hash"
                  #puts ograph.keys.to_s
                end
              end
            end

        end

        def getPath(graph,counter,path=[])
          puts 'Entered'
          if counter==0
            puts 'llegue a 0'
            puts "THe path is:"
            myp=[]
            graph.each {|i,p| myp+=[[p[2].value,p[1].value,p[0]]]}
            puts myp.to_s
            return path
          end
          val = graph[counter]
          if val.nil?
            return nil
          else
            path.unshift(val[2])
            puts '----'
            puts val[2].value
            return getPath(graph,val[0],path)
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
    def each(&b) #Misma duda
        #yield value
        children.each do |child|
            #yield "qlq"
            unless child.nil?
                b.call(child)
            end
        end
    end

    include BFS
end

#Repetir bfs, utilizando mixin.