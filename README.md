# Rbgraph
A simple and lightweight ruby implementation of graphs and traversal algorithms

## General Requirements

Install via rubygems

```gem install rbgraph```

or add it to your Gemfile

```gem 'rbgraph'```

## Basic objects

####*Graph*: 
Graphs can be undirected or directed.
```ruby
graph = Rbgraph::UndirectedGraph.new
graph = Rbgraph::DirectedGraph.new
```
Use ```graph.directed?``` to figure out if a graph is directed or not.
The graph object has the ```nodes``` and ```edges``` properties which are ruby hashes, the keys being the ids of each object respectively.

####*Nodes*:
Every node should have an already set ```id``` property upon initialization.
Nodes also carry data, in the data attribute which is a ruby hash.
Usually you will not need initialize a node directly, but rather just add one with the desired properties in the graph.
```ruby
graph = Rbgraph::UndirectedGraph.new
# graph.add_node!(node_id, node_data, &block)
# Add a node with id = 5 and attached data t = [0, 4, 19].
node = graph.add_node!(5, {t: [0, 4, 19]})
```
By default if a node with the same id already exists, then ```add_node!``` does nothing unless given a block.
```ruby
# Add another node with id = 5 and attached data t = [1, 5, 20].
node = graph.add_node!(5, {t: [1, 5, 20]}) # does nothing
node = graph.add_node!(5, {t: [1, 5, 20]}) do |graph, existing_node, new_node_data|
  existing_node.data[:t] += new_node_data[:t]
end
node.data[:t] # => [0, 4, 19, 1, 5, 20]
graph.nodes[5].data[:t] # => [0, 4, 19, 1, 5, 20]
```
Nodes have the following properties:
* id
* data
* neighbors (respects directional/undirectional)
* edges (will contain both incoming and outgoing edges)
* graph

and the following methods:

* out_degree
* outgoing_edges
* in_degree
* incoming_edges
* parent (works only in directed graph - return the node that has only one edge towards this one if any)
* ancestors (works only in directed graph - returns the list of parents for this node up to the root if the graph is not cyclic)
* root (works only in directed graph - return the root of this node if the graph is not cyclic)


####*Edges*:
Edges connect nodes with either a one-way (directional graph) or two-way (undirectional graph) link.
Edges have an internally computed id, which is a string representation of the ids of the nodes they connect.
Each node can also have a ```weight``` attribute, and a ```kind``` attribute, as well as carry additional data as a ruby hash in its ```data``` attribute.
Again you do not want to instantiate edges directly, rather you would just add them to the graph.
```ruby
graph = Rbgraph::UndirectedGraph.new
# graph.add_edge!(node1, node2, weight = 1, kind = nil, edge_data = {}, &block)
# Add an edge connecting nodes with id 2 and 3
edge1 = graph.add_edge!({id: 2}, {id: 3})
edge1.weight # => 1
# Add an edge connecting nodes with id 1 and 4, weight = 3, kind = "friendship" and data = {created_at: <some_date>}
edge2 = graph.add_edge!({id: 1}, {id: 4}, 3, "friendship", {created_at: <some_date>})
edge1.weight # => 3
```
You can add an edge even if the nodes that will be connected do not yet exist in the graph.
They will be added automatically when you call ```add_edge!```.
When adding an edge that already exists, i.e. connects the same nodes and is of the same kind, then the existing edge increases its weight by the amount present in the new edge, unless you specify a block to provide custom behavior.
```ruby
edge1 = graph.add_edge!({id: 2}, {id: 3})
edge1.weight # => 2
edge1 = graph.add_edge!({id: 2}, {id: 3}, 0)
edge1.weight # => 2
edge1 = graph.add_edge!({id: 2}, {id: 3}, 1, nil, {some: :data}) do |graph, existing_edge, new_edge|
  existing_edge.data.merge!(new_edge.data)
end
edge1.weight # => 2 (weight doesn't change when you provide a block it is your responsibility to increase it if you want)
edge1.data # => {some: :data}

edge3 = graph.add_edge!({id: 2}, {id: 3}, 1, "something")
edge3.id != edge1.id # => true
```

Edges have the following properties:
* id
* data
* node1
* node2
* weight
* kind
* graph

and the following methods:

* has_node?(some_node)
* other_node(some_node)
* different_node(some_node)
* out_for?(some_node)
* in_for?(some_node)


## Examples

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
