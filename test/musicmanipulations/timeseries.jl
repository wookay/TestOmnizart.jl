using Jive
@useinside Main module test_musicmanipulations_timeseries

using Test
using MIDI
using MusicManipulations # timeseries
using Statistics # mean

midi = load(normpath(@__DIR__, "../../midi_files/bogo1.mid"))

notes = getnotes(midi, 2) # trackno

hundred_notes = notes[1:100]

grid = 0:1//2:1
tvec, tseries = timeseries(hundred_notes, :pitch, mean, grid)
@test length(tvec) == 64
@test length(tseries) == 64

segmented_notes = segment(hundred_notes, grid)
@test length(segmented_notes) == 129

end # @useinside Main module test_musicmanipulations_timeseries
