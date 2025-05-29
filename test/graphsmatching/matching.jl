module test_graphsmatching_matching

using Test
using Graphs # complete_graph
using GraphsMatching # minimum_weight_perfect_matching maximum_weight_matching
using JuMP # optimizer_with_attributes
using Cbc

has_CI = haskey(ENV, "CI")

# from GraphsMatching/src/blossomv.jl
import GraphsMatching: minimum_weight_perfect_matching
function minimum_weight_perfect_matching(g::Graph, w::Dict{E,Int}) where {E<:Edge}
    m = BlossomV.Matching(nv(g))
    BlossomV.verbose(m, has_CI) ### verbose
    for (e, c) in w
        BlossomV.add_edge(m, src(e) - 1, dst(e) - 1, c)
    end
    BlossomV.solve(m)

    mate = fill(-1, nv(g))
    totweight = zero(U)
    for i in 1:nv(g)
        j = BlossomV.get_match(m, i - 1) + 1
        mate[i] = j <= 0 ? -1 : j
        if i < j
            totweight += w[Edge(i, j)]
        end
    end
    return MatchingResult(totweight, mate)
end


# from GraphsMatching/test/runtests.jl

###
g = Graph(4)

w = Dict{Edge{Int}, Float64}()
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

# BlossomV.verbose(m, true)
# perfect matching with 4 nodes and 4 edges
#     starting init...done [0.000 secs]. 0 trees
#     .
# done [0.000 secs]. 0 grows, 0 expands, 0 shrinks
#     expands: [0.000 secs], shrinks: [0.000 secs], dual updates: [0.000 secs]

opt = optimizer_with_attributes(Cbc.Optimizer, "LogLevel" => 0)
# Presolve 0 (-4) rows, 0 (-3) columns and 0 (-6) elements
# Optimal - objective value 3
# After Postsolve, objective 3, infeasibilities - dual 0 (0), primal 0 (0)
# Optimal objective 3 - 0 iterations time 0.002, Presolve 0.00
match = maximum_weight_matching(g, opt, w)
@test match.weight == 3.0
@test match.mate == [4, -1, -1, 1]

end # module test_graphsmatching_matching
