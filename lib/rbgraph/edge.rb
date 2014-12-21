module Rbgraph

  class Edge

    attr_accessor :id
    attr_accessor :node1
    attr_accessor :node2
    attr_accessor :attributes

    def initialize(node1, node2, attributes = {})
      self.node1 = node1
      self.node2 = node2
      self.attributes = attributes
      self.id = attributes[:id] || "#{node1.id}=#{attributes[:kind]}=#{node2.id}"
    end

    def ==(node)
      self.id == node.id
    end
    alias_method :==, :eql?

    def hash
      id
    end

    def other_node(node)
      ([node1, node2] - [node]).first
    end

    def merge(edge)
      attributes.merge!(edge.attributes.reject { |k, v| k == :id })
      self
    end

  end

end
