using Jive
@useinside Main module test_midi_basic

# https://juliamusic.github.io/JuliaMusic_documentation.jl/latest/midi/io/#Basic-MIDI-structures

using Test
using MIDI

midi = load(normpath(@__DIR__, "../../midi_files/bogo1.mid"))

# from MIDI/src/midifile.jl

#     MIDIFile <: Any
# Type representing a file of MIDI data.
#
## Fields
# * `format::UInt16` : The format of the file. Can be 0, 1 or 2.
# * `tpq::Int16` : The time division of the track, ticks-per-quarter-note.
# * `tracks::Array{MIDITrack, 1}` : The array of contained tracks.
#
# mutable struct MIDIFile
#     format::UInt16 # Can be 0, 1 or 2
#     tpq::Int16 # The time division of the track. Ticks per quarter note
#     tracks::Vector{MIDITrack}
# end
midi

# Return the **initial** QPM (quarter notes per minute) where the given `MIDIFile` was exported at.
# This value is constant, and will not change even if the tempo change event is triggered.
# Returns 120 if not found.
# To get a list of QPM over time, use [`tempochanges`](@ref)
@test qpm(midi) == 120.0

# Return the BPM where the given `MIDIFile` was exported at.
# Returns QPM if not found.
@test bpm(midi) == 120.0

# Return the time signature of the given `MIDIFile`.
# Returns 4/4 if it doesn't find a time signature.
@test time_signature(midi) == "4/4"

# Return a vector of (position, tempo) tuples for all the tempo events in the given `MIDIFile`
# where position is in absolute time (from the beginning of the file) in ticks
# and tempo is in quarter notes per minute.
# Returns [(0, 120.0)] if there are no tempo events.
@test tempochanges(midi) == [(0, 120.0)]

# Return how many milliseconds is one tick, based
# on the quarter notes per minute `qpm` and ticks per quarter note `tpq`.
@test ms_per_tick(midi) == 2.272727272727273

notes = getnotes(midi, 2)
@test notes.tpq == 220

# mutable struct Note
#   pitch    :: UInt8
#   velocity :: UInt8
#   position :: UInt64
#   duration :: UInt64
#   channel  :: UInt8
Note

first_note = first(notes)
last_note  = last(notes)
@test string(first_note) == "Note A3  | vel = 113 | pos = 273, dur = 70"
@test string(last_note)  == "Note E5  | vel = 122 | pos = 99563, dur = 123"
@test first_note == Note(0x39, 0x71, 0x0000000000000111, 0x0000000000000046, 0x00)
@test pitch_to_name(0x39; flat=true) == "A3"
@test Int(0x71) == 113
@test Int(0x0000000000000111) == 273
@test Int(0x0000000000000046) == 70

# Return how many milliseconds elapsed at `note` position.
# Matric time calculations need `tpq` field of `MIDIFile`.
# Apparently it only make sense if the `note` coming from `MIDIFile`, otherwise you can't get the correct result.
@test metric_time(midi, first_note) ==     620.4545454545455
@test metric_time(midi, last_note)  == 226_279.54545454547

# Return `note` duration time in milliseconds.
# Matric time calculations need `tpq` field of `MIDIFile`.
# Apparently it only make sense if the `note` coming from `MIDIFile`, otherwise you can't get the correct result.
@test duration_metric_time(midi, first_note) == 159.0909090909091

end # module test_midi_basic
