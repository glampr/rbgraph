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

  it "should traverse an undirected graph and find path from a to b" do
    graph = Rbgraph::UndirectedGraph.new()
    graph2 = Rbgraph::UndirectedGraph.new()
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
    graph2.add_edge!({id: -1}, {id: -2})

    t = Rbgraph::Traverser::BfsTraverser.new(graph)

    a = graph.nodes[1]
    b = graph.nodes[4]
    c = graph.nodes[6]
    d = graph.nodes[8]
    e = graph.nodes[9]
    f = graph2.nodes[-1]

    path = t.bfs_between_a_and_b(a, f)
    expect(path).to be_nil

    path = t.bfs_between_a_and_b(a, a)
    expect(path.length).to eq(1)
    expect(path[0].id).to eq(a.id)
    expect(path[-1].id).to eq(a.id)

    path = t.bfs_between_a_and_b(a, b)
    expect(path.length).to eq(2)
    expect(path[0].id).to eq(a.id)
    expect(path[-1].id).to eq(b.id)

    path = t.bfs_between_a_and_b(e, d)
    expect(path.length).to eq(3)
    expect(path[0].id).to eq(e.id)
    expect(path[-1].id).to eq(d.id)

    path = t.bfs_between_a_and_b(a, d)
    expect(path.length).to eq(0)
  end

  it "should traverse a directed graph and find path from a to b" do
    graph = Rbgraph::DirectedGraph.new()
    graph.add_edge!({id: 1}, {id: 2})
    graph.add_edge!({id: 2}, {id: 3})
    graph.add_edge!({id: 1}, {id: 4})
    graph.add_edge!({id: 4}, {id: 5})

    t = Rbgraph::Traverser::BfsTraverser.new(graph)

    a = graph.nodes[1]
    b = graph.nodes[3]
    c = graph.nodes[5]

    path = t.bfs_between_a_and_b(a, b)
    expect(path.length).to eq(3)
    expect(path[0].id).to eq(a.id)
    expect(path[-1].id).to eq(b.id)

    path = t.bfs_between_a_and_b(b, c)
    expect(path).to be_empty
  end

  it "should traverse a directed graph and find path from a to b, without respecting the direction" do
    graph = Rbgraph::DirectedGraph.new()
    graph.add_edge!({id: 1}, {id: 2})
    graph.add_edge!({id: 2}, {id: 3})
    graph.add_edge!({id: 1}, {id: 4})
    graph.add_edge!({id: 4}, {id: 5})

    t = Rbgraph::Traverser::BfsTraverser.new(graph)

    a = graph.nodes[3]
    b = graph.nodes[5]

    path = t.bfs_between_a_and_b(a, b, respect_direction: false)
    expect(path.length).to eq(5)
    expect(path[0].id).to eq(a.id)
    expect(path[-1].id).to eq(b.id)
  end


end
