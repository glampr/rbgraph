require 'json/add/core'

module Rbgraph

  autoload :Graph, 'rbgraph/graph'
  autoload :DirectedGraph, 'rbgraph/graphs/directed'
  autoload :UndirectedGraph, 'rbgraph/graphs/undirected'

  autoload :Node,  'rbgraph/node'
  autoload :Edge,  'rbgraph/edge'

  autoload :Traverser, 'rbgraph/traverser'

end
