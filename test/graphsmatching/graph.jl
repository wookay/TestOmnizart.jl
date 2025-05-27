module test_graphsmatching_graph

using Test
using Graphs # complete_graph
using GraphsMatching # minimum_weight_perfect_matching maximum_weight_matching
using JuMP # optimizer_with_attributes
using Cbc

# from GraphsMatching/test/runtests.jl

###
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

###
g = Graph(4)
add_edge!(g, 1, 3)
add_edge!(g, 1, 4)
add_edge!(g, 2, 4)

w = zeros(4, 4)
w[1, 3] = 1
w[1, 4] = 3
w[2, 4] = 1

opt = optimizer_with_attributes(Cbc.Optimizer, "LogLevel" => 0)
match = maximum_weight_matching(g, opt, w)
@test match.weight == 3.0
@test match.mate == [4, -1, -1, 1]

end # module test_graphsmatching_graph
