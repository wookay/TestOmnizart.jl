using Jive
@useinside Main module test_midi_noteplotter

using Test
using MIDI

midi = load(normpath(@__DIR__, "../../midi_files/bogo1.mid"))

notes = getnotes(midi, 2)
@test notes isa Notes{Note}
@test notes.notes isa Vector{Note}
@test length(notes.notes) == 2122
@test notes.tpq == 220

# from MusicVisualizations/src/noteplotter.jl

# time to start plotting from
st = (notes[1].position ÷ notes.tpq) * notes.tpq
@test st == 0x00000000000000dc
@test Int(st) == 220

# time to stop plotting at, by default 16 quarter notes, i.e. four bars.
# Give `Inf` if you want to plot until the end of the notes.
fi = st + 16notes.tpq
@test fi == 0x0000000000000e9c
@test Int(fi) == 3740

# a grid to plot along with the notes (by default the 16th notes).
# Give nothing if you don't want grid lines to be plotted.
grid = 0:0.25:1

end # module test_midi_noteplotter
