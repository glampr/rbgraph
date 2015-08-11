describe "TraverseSpec" do

  it "should traverse an undirected graph and find connected components" do
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
    c = t.connected_components
    expect(c.length).to eq(3)

    c = c.sort { |a, b| b.size <=> a.size }
    expect(c[0].size).to eq(7)
    expect(c[1].size).to eq(3)
    expect(c[2].size).to eq(2)
  end

  it "should traverse a directed graph and find connected components" do
    graph = Rbgraph::DirectedGraph.new()
    graph.add_edge!({id: 1}, {id: 0})
    graph.add_edge!({id: 2}, {id: 0})
    graph.add_edge!({id: 3}, {id: 0})
    graph.add_edge!({id: -1}, {id: 0})
    graph.add_edge!({id: -2}, {id: 0})
    graph.add_edge!({id: -3}, {id: 0})

    t = Rbgraph::Traverser::BfsTraverser.new(graph)
    c = t.connected_components
    expect(c.length).to eq(6)

    expect(c[0].size).to eq(2)
    expect(c[1].size).to eq(2)
    expect(c[2].size).to eq(2)
    expect(c[3].size).to eq(2)
    expect(c[4].size).to eq(2)
    expect(c[5].size).to eq(2)
  end

  it "should traverse a directed graph, treat it as undirected and find connected components" do
    graph = Rbgraph::DirectedGraph.new()
    graph.add_edge!({id: 1}, {id: 0})
    graph.add_edge!({id: 2}, {id: 0})
    graph.add_edge!({id: 3}, {id: 0})
    graph.add_edge!({id: -1}, {id: 0})
    graph.add_edge!({id: -2}, {id: 0})
    graph.add_edge!({id: -3}, {id: 0})

    t = Rbgraph::Traverser::BfsTraverser.new(graph)
    c = t.connected_components(respect_direction: false)
    expect(c.length).to eq(1)

    expect(c[0].size).to eq(7)
  end

end
