module test_graphsmatching_graph

using Test
using Graphs # complete_graph
using GraphsMatching

# from GraphsMatching/test/runtests.jl

g = complete_graph(4)

w = Dict{Edge, Float64}()
w[Edge(1, 3)] = 10
w[Edge(1, 4)] = 0.5
w[Edge(2, 3)] = 11
w[Edge(2, 4)] = 2
w[Edge(1, 2)] = 100

match = minimum_weight_perfect_matching(g, w, 50)
@test match.weight == 11.5
@test match.mate == [4, 3, 2, 1]

end # module test_graphsmatching_graph
