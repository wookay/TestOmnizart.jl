using Jive
@useinside Main module test_bach_pc

using Test
using MIDI
using Bach: PC, Fundamental, consecutive
using Mods: Mods
using Graphs # Graph Edge

const TYPE_VERTEX = UInt8
const TYPE_WEIGHT = UInt

function feed_edge(w::Dict{Edge{V}, W}, i_pc::V, j_pc::V, duration::W) where {V <: TYPE_VERTEX, W <: TYPE_WEIGHT}
    edge = Edge(i_pc, j_pc)
    if haskey(w, edge)
        w[edge] += duration
    else
        w[edge] = duration
    end
end

function top_values(d::Dict{K, V}, amount::Int)::Vector{Pair{K, V}} where {K, V}
    sort(collect(d), by = last, rev = true)[1:amount]
end

midi = load(normpath(@__DIR__, "../../midi_files/bogo1.mid"))
notes = getnotes(midi, 2) # trackno
hundred_notes = notes[1:100]

c = consecutive(hundred_notes)
lastind = lastindex(c)
w = Dict{Edge{TYPE_VERTEX}, TYPE_WEIGHT}()
for (i, (i_note, j_note)) in enumerate(c)
    i_fm = Fundamental(i_note)
    j_fm = Fundamental(j_note)
    i_pc = TYPE_VERTEX(Mods.value(i_fm.pc))
    j_pc = TYPE_VERTEX(Mods.value(j_fm.pc))
    feed_edge(w, i_pc, j_pc, i_note.duration)
    i == lastind && feed_edge(w, j_pc, j_pc, j_note.duration)
end

g = Graph(TYPE_VERTEX(only(PC.parameters)))

@test length(w) == 29
@test first(top_values(w, 10)) == (Edge(9, 0) => 1643)

end # @useinside Main module test_bach_pc
