describe "AbsorbSpec" do

  it "should allow a node to absord another node" do
    graph = Rbgraph::DirectedGraph.new()

    graph.add_edge!({id: 1}, {id: 2})
    graph.add_edge!({id: 2}, {id: 3})

    expect(graph.size).to eq(3)
    expect(graph.nodes[1].neighbors.size).to eq(1)
    expect(graph.nodes[2].neighbors.size).to eq(1)
    expect(graph.nodes[3].neighbors.size).to eq(0)
    expect(graph.edges["1==2"].weight).to eq(1)

    # graph.nodes[1].absorb!(graph.nodes[2])
    graph.merge_nodes!([1, 2])

    expect(graph.size).to eq(2)
    expect(graph.nodes[1].neighbors.size).to eq(1)
    expect(graph.nodes[2]).to be_nil
    expect(graph.nodes[3].neighbors.size).to eq(0)
    expect(graph.edges["1==3"].weight).to eq(1)

    graph.add_edge!({id: 1}, {id: 3})

    expect(graph.size).to eq(2)
    expect(graph.nodes[1].neighbors.size).to eq(1)
    expect(graph.nodes[2]).to be_nil
    expect(graph.nodes[3].neighbors.size).to eq(0)
    expect(graph.edges["1==3"].weight).to eq(2)


    graph = Rbgraph::DirectedGraph.new()

    graph.add_edge!({id: 1}, {id: 2})
    graph.add_edge!({id: 2}, {id: 3})
    graph.add_edge!({id: 1}, {id: 3})

    expect(graph.size).to eq(3)
    expect(graph.nodes[1].neighbors.size).to eq(2)
    expect(graph.nodes[2].neighbors.size).to eq(1)
    expect(graph.nodes[3].neighbors.size).to eq(0)
    expect(graph.edges["1==2"].weight).to eq(1)

    # graph.nodes[1].absorb!(graph.nodes[2])
    graph.merge_nodes!([1, 2])

    expect(graph.size).to eq(2)
    expect(graph.nodes[1].neighbors.size).to eq(1)
    expect(graph.nodes[2]).to be_nil
    expect(graph.nodes[3].neighbors.size).to eq(0)
    expect(graph.edges["1==3"].weight).to eq(2)
  end

end
