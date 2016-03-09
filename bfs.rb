
class BinTree
    attr_accessor :value, :left, :right

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


class GraphNode
    attr_accessor :value,   # Valor alamacenado en el nodo
                  :children # Arreglo de sucesores GraphNode
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