module Rbgraph

  class Node

    attr_accessor :id
    attr_accessor :graph
    attr_accessor :neighbors
    attr_accessor :edges
    attr_accessor :data

    def initialize(graph, id, data = {})
      raise "Node should have a non-nil id!" if id.nil?
      self.id         = id
      self.neighbors  = {}
      self.edges      = {}
      self.data       = data
    end

    def ==(node)
      self.id == node.id
    end
    alias_method :==, :eql?

    def hash
      id.hash
    end

    def attributes
      {id: id, data: data}
    end

    def [](key)
      attributes.fetch(key.to_sym)
    end

    def connect_to(node, edge)
      if neighbors[node.id].nil? && edges[edge.id].nil?
        neighbors[node.id] ||= node
        edges[edge.id] ||= edge
      end
      self
    end

    def merge!(node, options = {})
      node.edges.values.group_by(&:kind).each do |kind, edges|
        edges.each do |edge|
          other_node = edge.other_node(node)
          edge_attributes = {weight: edge.weight, kind: kind || options[:edge_kind], data: edge.data}
          if edge.out_for?(node)
            graph.add_edge!(self, other_node, edge_attributes) unless other_node == self
          elsif edge.in_for?(node)
            graph.add_edge!(other_node, self, edge_attributes) unless other_node == self
          end
        end
      end
      graph.remove_node!(node)
    end

    def merge_data!(node)
      data.merge!(node.data)
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

    def to_json(options = {})
      attributes.to_json(options)
    end

  end

end
