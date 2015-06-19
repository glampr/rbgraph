module Rbgraph

    class UndirectedGraph < Graph

      def directed?
        false
      end

      def connect_nodes(node1, node2, edge)
        node1.connect_to(node2, edge)
        node2.connect_to(node1, edge)
      end

    end

end
