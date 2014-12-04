module Rbgraph

    class DirectedGraph < Graph

      def connect_nodes(node1, node2, edge)
        node1.connect_to(node2, edge)
      end

    end

end
