# Rbgraph
A simple and lightweight ruby implementation of graphs and traversal algorithms

## General Requirements

Install via rubygems

```gem install rbgraph```

or add it to your Gemfile

```gem 'rbgraph'```

## Example

```ruby
graph = Rbgraph::UndirectedGraph.new()
graph.add_edge!({id: 1}, {id: 2})
graph.add_edge!({id: 2}, {id: 3})
graph.add_edge!({id: 1}, {id: 4})
graph.add_edge!({id: 4}, {id: 5})
graph.add_edge!({id: 3}, {id: 6})
graph.add_edge!({id: 7}, {id: 8})
graph.add_edge!({id: 7}, {id: 8})
graph.add_edge!({id: 7}, {id: 9})
graph.add_edge!({id: 10}, {id: 11})
graph.add_edge!({id: 12}, {id: 1})

t = Rbgraph::Traverser::BfsTraverser.new(graph)
t.connected_components.sort { |a, b| b.size <=> a.size }.each do |subgraph|
  puts subgraph.nodes.values.map(&:id).inspect
end
```

will output

```ruby
[1, 2, 4, 12, 3, 5, 6]
[7, 8, 9]
[10, 11]
```

Version 0.0.7+

Nodes support in and out degree.
```ruby
node.in_degree
node.out_degree
```
depending on if you constructed a Directed or Undirected graph.

Version 0.0.8+

Support for weighted edges.
```ruby
graph = Rbgraph::UndirectedGraph.new()
graph.add_edge!({id: 1}, {id: 2})
graph.add_edge!({id: 2}, {id: 3})
graph.edges["1==2"].weight => 1
graph.add_edge!({id: 1}, {id: 2})
graph.edges["1==2"].weight => 2
graph.add_edge!({id: 1}, {id: 2}, {weight: 3})
graph.edges["1==2"].weight => 5
```

Version 0.0.13+

Support for node merging.
```ruby
graph = Rbgraph::UndirectedGraph.new()
graph.add_edge!({id: 1}, {id: 2})
graph.add_edge!({id: 2}, {id: 3})
graph.add_edge!({id: 3}, {id: 4})

# 1 -> 2 -> 3 -> 4
graph.merge_nodes!([2, 3])
# 1 -> 2 => 4

# 1 -> 2 -> 3 -> 4
graph.merge_nodes!([2, 3], {id: 5})
# 1 -> 5 => 4
```

Version 0.0.15+

Support for node/edge JSON rendering.
```ruby
graph = Rbgraph::UndirectedGraph.new()
graph.add_edge!({id: 1, level: "1"}, {id: 2, level: 8}, {weight: 14})
graph.nodes[1].to_json
# => {"id":1,"level":"1"}
graph.edges["1==2"].to_json
# => {"id":"1==2","directed":false,"weight":14}
```

Version 0.2.0+

Can now find connected components in a directed graph, without respecting the direction
```ruby
graph = Rbgraph::DirectedGraph.new()
... # add nodes and edges
t = Rbgraph::Traverser::BfsTraverser.new(graph)
c = t.connected_components(respect_direction: false)
```

### Disclaimer
This project is written on a need to use basis for inclusion to other projects I'm working on for now, so completion is not an immediate goal.
