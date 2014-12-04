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
      edge = if edges[edge.id].nil?
        edges[edge.id] = edge
      else
        edges[edge.id].merge(edge)
      end
      connect_nodes(node1, node2, edge)
      edge
    end

    def connect_nodes(node1, node2, edge)
      raise NotImplementedError("Cannot connect nodes on a general graph! Use either Directed or Undirected subclasses")
    end

  end

end
