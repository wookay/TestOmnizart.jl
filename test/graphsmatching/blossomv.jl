module test_graphsmatching_blossomv

using Test
using BlossomV

# from BlossomV/test/runtests.jl
differences = [
    0 1 500
]

m = Matching(2) # defaults to Int32
for row_ii in 1:size(differences,1)
    n1,n2, c = differences[row_ii,:]
    add_edge(m,n1,n2,c)
end

# crash
# get_match(m, 0)

solve(m)
@test get_match(m, 0) == 1
@test get_match(m, 1) == 0

end # module test_graphsmatching_blossomv
