describe "BasicSpec" do

  it "should build a simple undirected graph" do
    graph = Rbgraph::UndirectedGraph.new()
    expect(graph.edges.length).to eq(0)
    expect(graph.nodes.length).to eq(0)

    graph.add_edge!({id: 1}, {id: 2})
    expect(graph.edges.length).to eq(1)
    expect(graph.nodes.length).to eq(2)
    expect(graph.nodes[1].neighbors[2]).to be(graph.nodes[2])
    expect(graph.nodes[2].neighbors[1]).to be(graph.nodes[1])

    expect(graph.nodes[1].in_degree).to eq(1)
    expect(graph.nodes[1].out_degree).to eq(1)
    expect(graph.nodes[2].in_degree).to eq(1)
    expect(graph.nodes[2].out_degree).to eq(1)
  end

  it "should build a simple directed graph" do
    graph = Rbgraph::DirectedGraph.new()
    expect(graph.edges.length).to eq(0)
    expect(graph.nodes.length).to eq(0)

    graph.add_edge!({id: 1}, {id: 2})
    expect(graph.edges.length).to eq(1)
    expect(graph.nodes.length).to eq(2)
    expect(graph.nodes[1].neighbors[2]).to be(graph.nodes[2])
    expect(graph.nodes[2].neighbors).to be_empty

    expect(graph.nodes[1].in_degree).to eq(0)
    expect(graph.nodes[1].out_degree).to eq(1)
    expect(graph.nodes[2].in_degree).to eq(1)
    expect(graph.nodes[2].out_degree).to eq(0)
  end

  it "should be able to add and remove nodes and edges" do
    graph = Rbgraph::DirectedGraph.new()

    graph.add_edge!({id: 1}, {id: 2})
    graph.add_edge!({id: 2}, {id: 3})

    expect(graph.size).to eq(3)
    expect(graph.nodes[1].neighbors.size).to eq(1)
    expect(graph.nodes[2].neighbors.size).to eq(1)
    expect(graph.nodes[3].neighbors.size).to eq(0)

    graph.remove_node!(2)

    expect(graph.size).to eq(2)
    expect(graph.nodes[1].neighbors.size).to eq(0)
    expect(graph.nodes[2]).to be_nil
    expect(graph.nodes[3].neighbors.size).to eq(0)

    graph.add_edge!({id: 1}, {id: 3})

    expect(graph.size).to eq(2)
    expect(graph.nodes[1].neighbors.size).to eq(1)
    expect(graph.nodes[2]).to be_nil
    expect(graph.nodes[3].neighbors.size).to eq(0)


    graph = Rbgraph::UndirectedGraph.new()

    graph.add_edge!({id: 1}, {id: 2})
    graph.add_edge!({id: 2}, {id: 3})

    expect(graph.size).to eq(3)
    expect(graph.nodes[1].neighbors.size).to eq(1)
    expect(graph.nodes[2].neighbors.size).to eq(2)
    expect(graph.nodes[3].neighbors.size).to eq(1)

    graph.remove_node!(2)

    expect(graph.size).to eq(2)
    expect(graph.nodes[1].neighbors.size).to eq(0)
    expect(graph.nodes[2]).to be_nil
    expect(graph.nodes[3].neighbors.size).to eq(0)

    graph.add_edge!({id: 1}, {id: 3})

    expect(graph.size).to eq(2)
    expect(graph.nodes[1].neighbors.size).to eq(1)
    expect(graph.nodes[2]).to be_nil
    expect(graph.nodes[3].neighbors.size).to eq(1)
  end

  it "should be able to calculate edge weights" do
    graph = Rbgraph::DirectedGraph.new()

    graph.add_edge!({id: 1}, {id: 2})
    graph.add_edge!({id: 2}, {id: 3})

    expect(graph.size).to eq(3)
    expect(graph.edges["1==2"].weight).to eq(1)
    expect(graph.edges["2==3"].weight).to eq(1)

    graph.add_edge!({id: 2}, {id: 1})
    expect(graph.edges["1==2"].weight).to eq(1)
    expect(graph.edges["2==1"].weight).to eq(1)
    expect(graph.edges["2==3"].weight).to eq(1)

    graph.add_edge!({id: 1}, {id: 2})
    expect(graph.edges["1==2"].weight).to eq(2)
    expect(graph.edges["2==1"].weight).to eq(1)


    graph = Rbgraph::UndirectedGraph.new()

    graph.add_edge!({id: 1}, {id: 2})
    graph.add_edge!({id: 2}, {id: 3})

    expect(graph.size).to eq(3)
    expect(graph.edges["1==2"].weight).to eq(1)
    expect(graph.edges["2==3"].weight).to eq(1)

    graph.add_edge!({id: 2}, {id: 1})
    expect(graph.edges["1==2"].weight).to eq(2)
    expect(graph.edges["2==1"]).to be_nil
    expect(graph.edges["2==3"].weight).to eq(1)
  end

  it "should render graph objects in JSON" do
    graph = Rbgraph::UndirectedGraph.new()
    expect(graph.edges.length).to eq(0)
    expect(graph.nodes.length).to eq(0)

    graph.add_edge!({id: 1, level: "1"}, {id: 2, level: 8}, 14)
    expect(graph.nodes[1].to_json).to eq("{\"id\":1,\"level\":\"1\"}")
    expect(graph.nodes[2].to_json).to eq("{\"id\":2,\"level\":8}")
    expect(graph.edges["1==2"].to_json).to eq("{\"id\":\"1==2\",\"directed\":false,\"weight\":14}")
  end

end
