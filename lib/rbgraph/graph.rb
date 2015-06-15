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
      edge.node1.neighbors.delete(edge.node2.id)
      edge.node2.neighbors.delete(edge.node1.id)
      edge.node1.edges.delete(edge.id)
      edge.node2.edges.delete(edge.id)
      edges.delete(edge.id)
    end

    def merge_nodes!(node_ids, new_attrs = {})
      node_ids = node_ids.map { |node_id| nodes[node_id].nil? ? nil : node_id } .compact
      return nil if node_ids.empty?
      if new_attrs[:id].nil?
        new_node = nodes[node_ids.shift]
        new_node.merge(Node.new({id: 0}.merge(new_attrs)))
      else
        new_node = add_node!(new_attrs)
      end
      node_ids.each do |node_id|
        node = nodes[node_id]
        new_node.absorb!(node)
        raise "!!" if !nodes[node_id].nil?
      end
      new_node
    end

    def connect_nodes(node1, node2, edge)
      raise NotImplementedError("Cannot connect nodes on a general graph! Use either Directed or Undirected subclasses")
    end

    def inspect
      edges.map(&:inspect)
    end

  end

end
