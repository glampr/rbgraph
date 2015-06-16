module Rbgraph

  class Edge

    attr_accessor :id
    attr_accessor :graph
    attr_accessor :node1
    attr_accessor :node2
    attr_accessor :weight
    attr_accessor :directed
    attr_accessor :attributes

    def initialize(node1, node2, attributes = {})
      self.node1 = node1
      self.node2 = node2
      self.directed = !!attributes.delete(:directed)
      interpolated_node_ids = directed ? [node1.id, node2.id] : [node1.id, node2.id].sort
      self.id = attributes.delete(:id) || ("%s=#{attributes[:kind]}=%s" % interpolated_node_ids)
      self.weight = attributes.delete(:weight) || 1
      self.attributes = attributes
    end

    def ==(node)
      self.id == node.id
    end
    alias_method :==, :eql?

    def hash
      id
    end

    def has_node?(node)
      node == node1 || node == node2
    end

    def other_node(node)
      # ([node1, node2] - [node]).first ! Fails for edge connecting a node to itself
      node == node1 ? node2 : node1
    end

    def merge(edge)
      raise "Cannot merge directed and undirected edge!" if directed ^ edge.directed # XOR
      self.weight += edge.weight unless edge.weight.nil?
      attributes.merge!(edge.attributes)
      self
    end

    def out_for?(node)
      if directed
        node == node1
      else
        has_node?(node)
      end
    end

    def in_for?(node)
      if directed
        node == node2
      else
        has_node?(node)
      end
    end

    def original_attributes
      attributes.merge({directed: directed, weight: weight})
    end

    def inspect
      "<Rbgraph::Edge:##{id} (#{weight}) [#{node1.inspect} #{directed ? "=(#{attributes[:kind]})=>>" : "==(#{attributes[:kind]})=="} #{node2.inspect}] #{attributes.inspect}>"
    end

  end

end
