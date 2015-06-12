module Rbgraph

  class Graph

    attr_accessor :nodes
    attr_accessor :edges

    def initialize(nodes = {}, edges = {})
      self.nodes = nodes
      self.edges = edges
    end

    def size
      nodes.values.length
    end

    def add_node!(node)
      node = node.is_a?(Node) ? node : Node.new(node)
      node.graph = self
      if nodes[node.id].nil?
        nodes[node.id] = node
      else
        nodes[node.id].merge(node)
      end
      nodes[node.id]
    end

    def add_edge!(node1, node2, edge_attributes = {})
      node1 = add_node!(node1)
      node2 = add_node!(node2)
      edge = Edge.new(node1, node2, edge_attributes)
      edge.graph = self
      edge = if edges[edge.id].nil?
        edges[edge.id] = edge
      else
        edges[edge.id].merge(edge)
      end
      connect_nodes(node1, node2, edge)
      edge
    end

    def remove_node!(node)
      node = node.is_a?(Node) ? node : nodes[node]
      if node
        node.edges.values.each { |edge| remove_edge!(edge) }
        nodes.delete(node.id)
      end
    end

    def remove_edge!(edge)
      edge = edge.is_a?(Edge) ? edge : edges[edge]
      edge.node1.remove_neighbor(edge.node2)
      edge.node2.remove_neighbor(edge.node1)
      edges.delete(edge.id)
    end

    def merge_nodes!(node_ids, &block)
      node_ids = node_ids || yield
      first_node = nodes[node_ids.shift]
      if !first_node.nil? && !node_ids.empty?
        node_ids.each do |node_id|
          node = nodes[node_id]
          first_node.absorb!(node)
        end
      end
    end

    def connect_nodes(node1, node2, edge)
      raise NotImplementedError("Cannot connect nodes on a general graph! Use either Directed or Undirected subclasses")
    end

    def inspect
      edges.map(&:inspect)
    end

  end

end
