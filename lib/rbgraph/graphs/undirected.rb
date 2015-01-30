module Rbgraph

    class UndirectedGraph < Graph

      def add_edge!(node1, node2, edge_attributes = {})
        super(node1, node2, {directed: false}.merge(edge_attributes))
      end

      def connect_nodes(node1, node2, edge)
        node1.connect_to(node2, edge)
        node2.connect_to(node1, edge)
      end

    end

end
