module Rbgraph

  class Node

    attr_accessor :id
    attr_accessor :attributes
    attr_accessor :neighbors
    attr_accessor :edges

    def initialize(attributes = {})
      self.attributes = attributes
      raise "Node should have an id attribute!" if attributes[:id].nil?
      self.id = attributes[:id]
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
      neighbors[node.id] = node
      edges[edge.id] = edge
      self
    end

  end

end
