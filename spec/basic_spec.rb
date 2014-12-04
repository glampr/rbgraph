describe "BasicSpec" do

  it "should build a simple graph" do
    graph = Rbgraph::UndirectedGraph.new()
    expect(graph.edges.length).to eq(0)
    expect(graph.nodes.length).to eq(0)

    graph.add_edge!({id: 1}, {id: 2})
    expect(graph.edges.length).to eq(1)
    expect(graph.nodes.length).to eq(2)
    expect(graph.nodes[1].neighbors[2]).to be(graph.nodes[2])
    expect(graph.nodes[2].neighbors[1]).to be(graph.nodes[1])
  end

end
