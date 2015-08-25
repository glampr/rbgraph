module Rbgraph

  class Edge

    attr_accessor :id
    attr_accessor :graph
    attr_accessor :node1
    attr_accessor :node2
    attr_accessor :weight
    attr_accessor :kind
    attr_accessor :data

    def initialize(graph, node1, node2, weight, kind, data = {})
      self.graph  = graph
      self.node1  = node1
      self.node2  = node2
      self.weight = weight.nil? ? 1 : weight.to_i
      self.kind   = kind
      nodes_ids   = graph.directed? ? [node1.id, node2.id] : [node1.id, node2.id].sort
      self.id     = "%s=#{kind}=%s" % nodes_ids
      self.data   = data
    end

    def ==(node)
      self.id == node.id
    end
    alias_method :==, :eql?

    def hash
      id.hash
    end

    def attributes
      {id: id, weight: weight, kind: kind, data: data}
    end

    def has_node?(node)
      node == node1 || node == node2
    end

    def other_node(node)
      # ([node1, node2] - [node]).first ! Fails for edge connecting a node to itself
      node == node1 ? node2 : node1
    end

    def different_node(node)
      ([node1, node2] - [node]).first
    end

    def merge!(edge, &block)
      self.weight += edge.weight unless edge.weight.nil?
      raise "Cannot merging edges of different kind!" if kind != edge.kind
      data.merge!(edge.data, &block)
      graph.remove_edge!(edge)
      self
    end

    def out_for?(node)
      graph.directed? ? node == node1 : has_node?(node)
    end

    def in_for?(node)
      graph.directed? ? node == node2 : has_node?(node)
    end

    def to_s
      descr = graph.directed? ? ["=", "=>>"] : ["==", "=="]
      "[#{node1.id} %s(#{attributes[:kind]}(#{weight}))%s #{node2.id}]" % descr
    end

    def inspect
      "<Rbgraph::Edge:##{id} #{attributes.inspect}>"
    end

    if defined? ActiveSupport
      def as_json(options = {})
        attributes.reject { |k, v| v.nil? || (v.respond_to?(:empty?) && v.empty?) }
      end
    else
      def to_json(options = {})
        JSON.generate(attributes.reject { |k, v| v.nil? || (v.respond_to?(:empty?) && v.empty?) })
      end
    end

  end

end
