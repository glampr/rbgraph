module Rbgraph

  class Node

    attr_accessor :id
    attr_accessor :graph
    attr_accessor :neighbors
    attr_accessor :edges
    attr_accessor :data

    def initialize(graph, id, data = {})
      raise "Node should have a non-nil id!" if id.nil?
      self.graph      = graph
      self.id         = id
      self.neighbors  = {}
      self.edges      = {}
      self.data       = data || {}
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
      neighbors[node.id] ||= node
      edges[edge.id] ||= edge
      self
    end

    def merge!(node, options = {}, &block)
      if options[:keep_other_data]
        data.merge!(node.data)
      end
      node.edges.values.group_by(&:kind).each do |kind, edges|
        edges.each do |edge|
          other_node = edge.other_node(node)
          edge_kind = edge.kind || options[:edge_kind]
          unless other_node == self
            if edge.out_for?(node)
              graph.add_edge!(self, other_node, edge.weight, edge_kind, edge.data, &block)
            elsif edge.in_for?(node)
              graph.add_edge!(other_node, self, edge.weight, edge_kind, edge.data, &block)
            end
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

    def parent
      if graph.directed?
        incoming_edges_arr = incoming_edges.values
        case incoming_edges_arr.size
        when 0 then nil
        when 1 then incoming_edges_arr.first.different_node(self) ||
            raise("Node #{id} is connected to self!")
        else
          raise "Node #{id} has more than 1 incoming edges!"
        end
      end
    end

    def ancestors
      if graph.directed?
        nodes = {}
        up = parent
        if up.nil?
          return {}
        else
          nodes[up.id] = up
        end
        while !up.parent.nil?
          up = up.parent
          if nodes[up.id].nil?
            nodes[up.id] = up
          else
            raise "Cycle detected while getting ancestors of #{id}!"
          end
        end
        nodes
      else
        {}
      end
    end

    def root
      ancestors.values.last || self
    end

    def out_degree
      outgoing_edges.size
    end

    def in_degree
      incoming_edges.size
    end

    def inspect
      "<Rbgraph::Node:##{id} #{data.inspect}>"
    end

    if defined? ActiveSupport
      def as_json(options = {})
        attributes
      end
    else
      def to_json(options = {})
        JSON.generate(attributes)
      end
    end

  end

end
