using Jive
@useinside Main module test_graphsmatching_graph

using Test
using Graphs

g = SimpleDiGraph(UInt8(5))
add_edge!(g, 1, 3)
add_edge!(g, 1, 4)
add_edge!(g, 2, 4)

@test is_directed(g)
@test vertices(g) == Base.OneTo(5)
@test edges(g) isa Graphs.SimpleGraphs.SimpleEdgeIter{SimpleDiGraph{UInt8}}
@test weights(g) isa Graphs.DefaultDistance
@test has_edge(g, Edge(1, 3))

e = Edge(1, 3)
@test src(e) == 1
@test dst(e) == 3

w = Dict{Edge{Int}, Float64}()
w[Edge(1, 3)] = 10
w[Edge(1, 4)] = 0.5
w[Edge(2, 3)] = 11
w[Edge(2, 4)] = 2
w[Edge(1, 2)] = 100

end # module test_graphsmatching_graph
