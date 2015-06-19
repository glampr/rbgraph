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

    def directed?
      raise NotImplementedError
    end

    def find_or_build_node(node_or_attributes)
      if node_or_attributes.is_a?(Node)
        node
      else
        id = node_or_attributes.delete(:id)
        Node.new(self, id, node_or_attributes)
      end
    end

    def add_node!(node_id, node_data, &block)
      if nodes[node_id].nil?
        nodes[node_id] = Node.new(self, node_id, node_data)
      else
        yield(self, nodes[node.id], node_data) if block_given?
      end
      nodes[node_id]
    end

    def add_edge!(node1, node2, weight = 1, kind = nil, edge_data = {})
      node1 = add_node!(node1[:id], node1[:data])
      node2 = add_node!(node1[:id], node1[:data])
      edge = Edge.new(self, node1, node2, weight, kind, edge_data)
      edge = if edges[edge.id].nil?
        edges[edge.id] = edge
      else
        edges[edge.id].merge!(edge)
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

    def merge_nodes!(node_ids, new_node_id = nil, new_node_data = {})
      node_ids = nodes.values_at(*node_ids).compact
      return nil if node_ids.empty?
      new_node = if new_node_id.nil?
        # If new_node_id is nil then select the first from the list as the surviving node.
        new_node = nodes[node_ids.shift]
      else
        # Otherwise either check if a node with the given id exists, or create a new one.
        if nodes[new_node_id].nil?
          add_node!(new_node_id, new_node_data)
        else
          new_node = nodes[new_node_id]
          random_not_existent_id = nodes.keys.sort_by { |k| -k.to_s.length } .first.to_s + "_"
          new_node.merge!(Node.new(0, new_node_data))
          node_ids.delete(new_node_id)
        end
      end
      node_ids.each do |node_id|
        node = nodes[node_id]
        new_node.merge!(node)
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
