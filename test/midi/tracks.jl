using Jive
@useinside Main module test_midi_tracks

# https://juliamusic.github.io/JuliaMusic_documentation.jl/latest/midi/io/#Basic-MIDI-structures

using Test
using MIDI

midi = load(normpath(@__DIR__, "../../midi_files/bogo1.mid"))

note_on_event = MIDI.NoteOnEvent(273, 0x90, 57, 113)
@test string(note_on_event) == "MIDI.NoteOnEvent(273, 0x90, 57, 113)"
@test note_on_event.dT == 273
@test note_on_event.status == 0x90
@test note_on_event.note == 57
@test note_on_event.velocity == 113
"MIDI.NoteOnEvent(273, 0x90, 57, 113)"

track = midi.tracks[2]
e = track.events[1]
# @info e == MIDI.TrackNameEvent(0, 0x03, "Acoustic Grand Piano")
@test e.dT == 0
@test e.metatype == 0x03
@test e.text == "Acoustic Grand Piano"
@test string(e) == """MIDI.TrackNameEvent(0, 0x03, "Acoustic Grand Piano")"""

notes_in_track2 = getnotes(track)
@test notes_in_track2.tpq == 960

last_note = last(notes_in_track2)
@test metric_time(midi, last_note) == 226_279.54545454547
@test duration_metric_time(midi, last_note) == 279.54545454545456

@test tempochanges(midi)[1] == (0, 120.0)

end # @useinside Main module test_midi_tracks
