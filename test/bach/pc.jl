using Jive
@useinside Main module test_bach_pc

using Test
using Bach # PC consecutive
using MIDI
using Mods: Mods
using Graphs # SimpleDiGraph Edge
using TimeUnits: Compound
using Unitful: ms, μs, ns, ps, fs, as

const TYPE_VERTEX = UInt8
const TYPE_WEIGHT = UInt

function feed_edge(g::SimpleDiGraph{V}, w::Dict{Edge{V}, W}, i_pc::V, j_pc::V, duration::W) where {V <: TYPE_VERTEX, W <: TYPE_WEIGHT}
    edge = Edge(i_pc, j_pc)
    if haskey(w, edge)
        w[edge] += duration
    else
        w[edge] = duration
    end
    add_edge!(g, edge)
end

function top_values(d::Dict{K, V}, amount::Int)::Vector{Pair{K, V}} where {K, V}
    sort(collect(d), by = last, rev = true)[1:amount]
end

midi = load(normpath(@__DIR__, "../../midi_files/bogo1.mid"))
notes = getnotes(midi, 2) # trackno
hundred_notes = notes[1:100]

g = SimpleDiGraph(TYPE_VERTEX(only(PC.parameters)))

c = consecutive(hundred_notes)
lastind = lastindex(c)
w = Dict{Edge{TYPE_VERTEX}, TYPE_WEIGHT}()
for (i, (i_note, j_note)) in enumerate(c)
    i_fm = Fundamental(i_note)
    j_fm = Fundamental(j_note)
    i_pc = TYPE_VERTEX(Mods.value(i_fm.pc))
    j_pc = TYPE_VERTEX(Mods.value(j_fm.pc))
    feed_edge(g, w, i_pc, j_pc, i_note.duration)
    i == lastind && feed_edge(g, w, j_pc, j_pc, j_note.duration)
end

@test length(w) == 29
@test first(top_values(w, 10)) == (Edge(9, 0) => 1643)

@test qpm(midi) == 120.0 # quarter notes per minute

tpq = notes.tpq # ticks-per-quarter-note
@test tpq == 220
@test 16tpq == 3520 # 16 quarter notes

@test ms_per_tick(midi) == 2.272727272727273 == 1000 * 60 / (qpm(midi) * tpq)
@test Compound(2.272727272727273ms) == Compound(2ms, 272μs, 727ns, 272ps, 727fs, 273as)

@test time_signature(midi) == "4/4"

first_note = first(hundred_notes)
st = (first_note.position ÷ tpq) * tpq
@test first_note.position == 273
fi = st + 16tpq 
@test st == 220
@test fi == 3740

last_note = last(notes)
last_st = (last_note.position ÷ tpq) * tpq
@test last_note.position == 99563
@test last_st == 99440

function filter_notes(; notes::Vector{Note}, down_to::UInt, up_to::UInt)::Vector{Note}
    filter(notes) do note
        up_to >= note.position >= down_to
    end
end

fi_notes = filter_notes(; notes = hundred_notes.notes, down_to = st, up_to = fi)
@test length(fi_notes) == 31
@test lastindex(notes) == 2122

import Bach: edge_labels_func
function edge_labels_func(edge_n::Int, edge_src, edge_dst, from, to)
end

d = draw_graph(g)
svg = sprint(Base.show, MIME("image/svg+xml"), d)
# write(normpath(@__DIR__, "draw_graph.svg"), svg)

end # @useinside Main module test_bach_pc
