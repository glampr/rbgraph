describe "AbsorbSpec" do

  it "should allow a node to absord another node" do
    graph = Rbgraph::DirectedGraph.new()

    graph.add_edge!({id: 1, data: {level: 0}}, {id: 2})
    graph.add_edge!({id: 2}, {id: 3})

    expect(graph.size).to eq(3)
    expect(graph.nodes[1].graph).to be(graph)
    expect(graph.nodes[2].graph).to be(graph)
    expect(graph.nodes[3].graph).to be(graph)
    expect(graph.nodes[1].neighbors.size).to eq(1)
    expect(graph.nodes[2].neighbors.size).to eq(1)
    expect(graph.nodes[3].neighbors.size).to eq(0)
    expect(graph.edges["1==2"].weight).to eq(1)

    # graph.nodes[1].absorb!(graph.nodes[2])
    graph.merge_nodes!([1, 2], 1, {level: 1})

    expect(graph.size).to eq(2)
    expect(graph.nodes[1].neighbors.size).to eq(1)
    expect(graph.nodes[1].data[:level]).to eq(1)
    expect(graph.nodes[2]).to be_nil
    expect(graph.nodes[3].neighbors.size).to eq(0)
    expect(graph.edges["1==3"].weight).to eq(1)

    graph.add_edge!({id: 1}, {id: 3})

    expect(graph.size).to eq(2)
    expect(graph.nodes[1].neighbors.size).to eq(1)
    expect(graph.nodes[2]).to be_nil
    expect(graph.nodes[3].neighbors.size).to eq(0)
    expect(graph.edges["1==3"].weight).to eq(2)


    # # # # # # # # # # # # # # # # # # # # # # # # # # # #
    graph = Rbgraph::DirectedGraph.new()

    graph.add_edge!({id: 1, data: {level: 0}}, {id: 2})
    graph.add_edge!({id: 2}, {id: 3})
    graph.add_edge!({id: 1}, {id: 3})

    expect(graph.size).to eq(3)
    expect(graph.nodes[1].neighbors.size).to eq(2)
    expect(graph.nodes[2].neighbors.size).to eq(1)
    expect(graph.nodes[3].neighbors.size).to eq(0)
    expect(graph.edges["1==2"].weight).to eq(1)

    # graph.nodes[1].absorb!(graph.nodes[2])
    graph.merge_nodes!([1, 2], nil, {level: 1})

    expect(graph.size).to eq(2)
    expect(graph.nodes[1].neighbors.size).to eq(1)
    expect(graph.nodes[1].data[:level]).to eq(1)
    expect(graph.nodes[2]).to be_nil
    expect(graph.nodes[3].neighbors.size).to eq(0)
    expect(graph.edges["1==3"].weight).to eq(2)


    # # # # # # # # # # # # # # # # # # # # # # # # # # # #
    graph = Rbgraph::DirectedGraph.new()

    graph.add_edge!({id: 1}, {id: 2})
    graph.add_edge!({id: 1}, {id: 2})
    graph.add_edge!({id: 1}, {id: 3})
    graph.add_edge!({id: 2}, {id: 3})
    graph.add_edge!({id: 2}, {id: 4})
    graph.add_edge!({id: 3}, {id: 4})
    graph.add_edge!({id: 3}, {id: 4})
    graph.add_edge!({id: 3}, {id: 4})

    expect(graph.size).to eq(4)
    expect(graph.nodes[1].neighbors.size).to eq(2)
    expect(graph.nodes[2].neighbors.size).to eq(2)
    expect(graph.nodes[3].neighbors.size).to eq(1)
    expect(graph.nodes[4].neighbors.size).to eq(0)
    expect(graph.edges["1==2"].weight).to eq(2)
    expect(graph.edges["3==4"].weight).to eq(3)

    # graph.nodes[1].absorb!(graph.nodes[2])
    graph.merge_nodes!([2, 3], 5)

    expect(graph.size).to eq(3)
    expect(graph.nodes[1].neighbors.size).to eq(1)
    expect(graph.nodes[5].neighbors.size).to eq(1)
    expect(graph.edges["1==5"].weight).to eq(3)
    expect(graph.edges["5==4"].weight).to eq(4)
  end

end
