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


### Disclaimer
This project is written on a need to use basis for inclusion to other projects I'm working on for now, so completion is not an immediate goal.
