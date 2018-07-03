module Rbgraph
  module Traverser

    class BfsTraverser

      attr_accessor :graph

      def initialize(graph)
        self.graph = graph
      end

      def connected_components(options = {})
        @connected_subgraphs = []
        @unvisited_nodes = Set.new [*graph.nodes.values]
        @visited_nodes = Set.new
        @queue = Queue.new

        while !@unvisited_nodes.empty? do
          root = @unvisited_nodes.to_a.first
          @unvisited_nodes.delete(@unvisited_nodes.to_a.first)
          @connected_subgraphs << bfs_from_root(root, options.merge(sticky: true))
        end
        @connected_subgraphs
      end

      def bfs_from_root(root, options = {})
        if !options[:sticky]
          @unvisited_nodes = Set.new [*graph.nodes.values]
          @visited_nodes = Set.new
          @queue = Queue.new
        end

        clear_backtracking_info

        subgraph = graph.class.new
        @visited_nodes.add(root)
        @queue.enq(root)
        while !@queue.empty? do
          t = @queue.deq
          @unvisited_nodes.delete(t)
          yield_value = yield(t) if block_given? # do sth on current node
          break if yield_value == :break
          subgraph.nodes[t.id] ||= t
          t.edges.each do |eid, edge|
            next if graph.directed? && !edge.out_for?(t) unless options[:respect_direction] == false
            neighbor = edge.other_node(t)
            subgraph.edges[eid] ||= edge
            subgraph.nodes[neighbor.id] ||= neighbor
            if !@visited_nodes.include?(neighbor)
              @visited_nodes.add(neighbor)
              @queue.enq(neighbor)
              neighbor.data[:__bfs_prev_node] ||= t
              @__bfs_prev_node_dirty = true
            end
          end
        end
        subgraph
      end

      def bfs_between_a_and_b(a, b, options = {})
        if graph.nodes[a.id].nil? || graph.nodes[b.id].nil?
          return nil
        end

        if a.id == b.id # a is the same as b
          return [a]
        end

        if !a.neighbors[b.id].nil? # a and b are just one step away
          return [a, b]
        end

        bfs_from_root(a, options) do |current_node|
          :break if current_node.id == b.id # destination node found! return ':break' in the block to stop traversing!
        end

        if b.data[:__bfs_prev_node].nil?
          return [] # no path found
        end

        path = [b]

        while path[-1].id != a.id do
          path << path[-1].data[:__bfs_prev_node]
        end

        path.reverse
      end

      private

      def clear_backtracking_info
        if @__bfs_prev_node_dirty
          graph.nodes.each do |node_id, node|
            node.data[:__bfs_prev_node] = nil
          end
        end
      end

    end

  end
end
