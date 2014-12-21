module Rbgraph
  module Traverser

    class BfsTraverser

      attr_accessor :graph
      attr_accessor :connected_subgraphs
      attr_accessor :visited_nodes
      attr_accessor :unvisited_nodes
      attr_accessor :queue

      def initialize(graph)
        self.graph = graph
        self.connected_subgraphs = []
        self.unvisited_nodes = Set.new [*graph.nodes.values]
      end

      def connected_components
        self.visited_nodes = Set.new
        self.queue = Queue.new

        while !unvisited_nodes.empty? do
          root = unvisited_nodes.to_a.first
          unvisited_nodes.delete(unvisited_nodes.to_a.first)
          self.connected_subgraphs << bfs_from_root(root)
        end
        connected_subgraphs
      end

      def bfs_from_root(root)
        subgraph = graph.class.new
        visited_nodes.add(root)
        queue.enq(root)
        while !queue.empty? do
          t = queue.deq
          unvisited_nodes.delete(t)
          yield(t) if block_given? # do sth on current node
          subgraph.nodes[t.id] ||= t
          t.edges.each do |eid, edge|
            neighbor = edge.other_node(t)
            subgraph.edges[eid] ||= edge
            subgraph.nodes[neighbor.id] ||= neighbor
            if !visited_nodes.include?(neighbor)
              visited_nodes.add(neighbor)
              queue.enq(neighbor)
            end
          end
        end
        subgraph
      end

    end

  end
end
