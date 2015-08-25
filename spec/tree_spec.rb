describe "TreeSpec" do

  it "should find a node's parent, ancestors and root in a tree" do
    graph = Rbgraph::DirectedGraph.new()

    graph.add_edge!({id: "r"}, {id: "l1.a"})
    graph.add_edge!({id: "r"}, {id: "l1.b"})
    graph.add_edge!({id: "r"}, {id: "l1.c"})

    graph.add_edge!({id: "l1.a"}, {id: "l2.a"})
    graph.add_edge!({id: "l1.a"}, {id: "l2.b"})
    graph.add_edge!({id: "l1.a"}, {id: "l2.c"})
    graph.add_edge!({id: "l1.b"}, {id: "l2.d"})
    graph.add_edge!({id: "l1.c"}, {id: "l2.e"})
    graph.add_edge!({id: "l1.c"}, {id: "l2.f"})

    graph.add_edge!({id: "l2.e"}, {id: "l3.a"})
    graph.add_edge!({id: "l2.d"}, {id: "l3.b"})

    expect(graph.nodes["r"].parent).to be_nil
    expect(graph.nodes["l3.b"].parent).to be(graph.nodes["l2.d"])
    expect(graph.nodes["l3.a"].parent).to be(graph.nodes["l2.e"])
    expect(graph.nodes["l2.c"].parent).to be(graph.nodes["l1.a"])
    expect(graph.nodes["l1.c"].parent).to be(graph.nodes["r"])

    expect(graph.nodes["l3.b"].root).to be(graph.nodes["r"])
    expect(graph.nodes["l3.a"].root).to be(graph.nodes["r"])
    expect(graph.nodes["l2.a"].root).to be(graph.nodes["r"])
    expect(graph.nodes["l2.b"].root).to be(graph.nodes["r"])
    expect(graph.nodes["l2.c"].root).to be(graph.nodes["r"])
    expect(graph.nodes["l1.b"].root).to be(graph.nodes["r"])
  end

  it "should fail to find a node's parent, if the graph is not a tree" do
    graph = Rbgraph::DirectedGraph.new()

    graph.add_edge!({id: "l1.a"}, {id: "l2.a"})
    graph.add_edge!({id: "l1.b"}, {id: "l2.a"})
    graph.add_edge!({id: "l1.c"}, {id: "l1.c"})
    graph.add_edge!({id: "l1.c"}, {id: "l1.c"})

    expect{ graph.nodes["l2.a"].parent }.to raise_error("Node l2.a has more than 1 incoming edges!")
    expect{ graph.nodes["l1.c"].parent }.to raise_error("Node l1.c is connected to self!")
  end

  it "should fail to find a node's root, if the graph contains a cycle" do
    graph = Rbgraph::DirectedGraph.new()

    graph.add_edge!({id: "a"}, {id: "b"})
    graph.add_edge!({id: "b"}, {id: "c"})
    graph.add_edge!({id: "c"}, {id: "d"})
    graph.add_edge!({id: "d"}, {id: "a"})
    graph.add_edge!({id: "d"}, {id: "e"})
    graph.add_edge!({id: "e"}, {id: "f"})
    graph.add_edge!({id: "f"}, {id: "g"})
    graph.add_edge!({id: "f"}, {id: "h"})
    graph.add_edge!({id: "f"}, {id: "i"})

    expect{ graph.nodes["c"].root }.to raise_error("Cycle detected while getting ancestors of c!")
    expect{ graph.nodes["i"].root }.to raise_error("Cycle detected while getting ancestors of i!")
  end

end
