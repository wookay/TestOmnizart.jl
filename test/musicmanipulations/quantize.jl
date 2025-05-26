using Jive
@useinside Main module test_musicmanipulations_quantize

using Test
using MIDI
using MusicManipulations # note_to_fundamental
using .MusicManipulations: scale_identification, SCALES
using Unitful: ms, μs, ns, ps, fs, as
using TimeUnits # Compound
using IterTools # partition

midi = load(normpath(@__DIR__, "../../midi_files/bogo1.mid"))

notes = getnotes(midi, 2) # trackno

# MIDI/src/midifile.jl
import MIDI: metric_time
function metric_time(tempo_changes::Vector, tpq, note::AbstractNote)::Float64
    # get all tempo change event before note
    tc_tuples = filter(x->x[1]<=note.position, tempo_changes)
    # how many ticks between two tempo changes event
    tempo_ticks = map(x->x[2][1]-x[1][1],partition(tc_tuples,2,1))
    push!(tempo_ticks,note.position-last(tc_tuples)[1])
    return mapreduce(x -> ms_per_tick(tpq, x[1][2]) * x[2], +, zip(tc_tuples,tempo_ticks))
end

function get_number_of_quarters(notes, index)
    tpq = notes.tpq
    note = notes[index]
    number_of_quarters = div(note.position, tpq)
    (Int(note.position), Int(number_of_quarters))
end

function get_metric_time(tempo_changes::Vector, notes, index)
    metric_t = metric_time(tempo_changes, notes.tpq, notes[index])
    Compound((metric_t)ms)
end

tempo_changes = tempochanges(midi)
@test get_metric_time(tempo_changes, notes, 1) ==
      Compound(620.454_545_454_545_5ms) ==
      Compound(620ms, 454μs, 545ns, 454ps, 545fs, 500as)

@test get_number_of_quarters(notes,    1) == (273, 1)
@test get_number_of_quarters(notes,    3) == (449, 2)
@test get_number_of_quarters(notes,    6) == (788, 3)
@test get_number_of_quarters(notes,    8) == (1003, 4)
@test get_number_of_quarters(notes,   10) == (1250, 5)
@test get_number_of_quarters(notes, 2122) == (99563, 452)
@test lastindex(notes) == 2122

end # @useinside Main module test_musicmanipulations_quantize
