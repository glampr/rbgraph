module Rbgraph

    class DirectedGraph < Graph

      def directed?
        true
      end

      def connect_nodes(node1, node2, edge)
        node1.connect_to(node2, edge)
        if node2.edges[edge.id].nil?
          node2.edges[edge.id] ||= edge
        end
      end

    end

end
