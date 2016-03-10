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

    def each() #duda preguntar si es each(b) o asi
        yield value
        unless left.nil?
            left.each {|leftch| yield leftch}
        end
        unless right.nil?
            right.each {|rightch| yield rightch}
        end
    end
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
    def each() #Misma duda
        yield value
        unless children.empty?
            children.each do |child|
                #yield "qlq"
                unless child.nil?
                    child.each {|ichild| yield ichild}
                end
            end
        end
    end
end

#Repetir bfs, utilizando mixin.