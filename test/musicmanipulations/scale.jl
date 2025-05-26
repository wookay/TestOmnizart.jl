using Jive
@useinside Main module test_musicmanipulations_scale

using Test
using MusicManipulations # note_to_fundamental
using .MusicManipulations: scale_identification, SCALES
using MIDI

midi = load(normpath(@__DIR__, "../../midi_files/bogo1.mid"))

notes = getnotes(midi, 2) # trackno
hundred_notes = notes[1:100]
@test note_to_fundamental(hundred_notes)[1:5] == split("A C E A G♯")

@test SCALES["A Major/F♯ minor"] == ["C♯", "D", "E", "F♯", "G♯", "A", "B"]
@test length(SCALES) == 35

# scale_identification
@test scale_identification(hundred_notes) == "A minor harmonic"
fund = note_to_fundamental(hundred_notes)
pitch_freq = pitch_frequency(fund)
@test pitch_freq == split("A E C G♯ B D F")

end # module test_musicmanipulations_scale
