module Rbgraph

  class Node

    attr_accessor :id
    attr_accessor :graph
    attr_accessor :attributes
    attr_accessor :neighbors
    attr_accessor :edges

    def initialize(attributes = {})
      self.attributes = attributes
      raise "Node should have an id attribute!" if attributes[:id].nil?
      self.id = attributes.delete(:id)
      self.neighbors = {}
      self.edges = {}
    end

    def ==(node)
      self.id == node.id
    end
    alias_method :==, :eql?

    def hash
      id
    end

    def merge(node)
      attributes.merge!(node.attributes.reject { |k, v| k == :id })
      self
    end

    def connect_to(node, edge)
      if neighbors[node.id].nil? && edges[edge.id].nil?
        neighbors[node.id] ||= node
        edges[edge.id] ||= edge
      end
      self
    end

    def absorb!(node)
      node.edges.values.each do |edge|
        other_node = edge.other_node(node)
        if edge.out_for?(node)
          graph.add_edge!(self, other_node, edge.original_attributes) unless other_node == self
        elsif edge.in_for?(node)
          graph.add_edge!(other_node, self, edge.original_attributes) unless other_node == self
        end
      end
      graph.remove_node!(node)
    end

    def outgoing_edges
      edges.select { |eid, edge| edge.out_for?(self) }
    end

    def incoming_edges
      edges.select { |eid, edge| edge.in_for?(self) }
    end

    def out_degree
      outgoing_edges.size
    end

    def in_degree
      incoming_edges.size
    end

    def inspect
      "<Rbgraph::Node:##{id} #{attributes.inspect}>"
    end

  end

end
