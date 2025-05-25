using Jive
@useinside Main module test_midi_tracks

# https://juliamusic.github.io/JuliaMusic_documentation.jl/latest/midi/io/#Basic-MIDI-structures

using Test
using MIDI

midi = load(normpath(@__DIR__, "../../midi_files/bogo1.mid"))

# The number of ticks per quarter note 
@test midi.tpq == 220

note_on_event = MIDI.NoteOnEvent(273, 0x90, 57, 113)
@test string(note_on_event) == "MIDI.NoteOnEvent(273, 0x90, 57, 113)"
@test note_on_event.dT == 273
@test note_on_event.status == 0x90
@test note_on_event.note == 57
@test note_on_event.velocity == 113
"MIDI.NoteOnEvent(273, 0x90, 57, 113)"

track = midi.tracks[2]
@test trackname(track) == "Acoustic Grand Piano"
e::MIDI.TrackNameEvent = track.events[1]
@test e.dT == 0
@test e.metatype == 0x03
@test e.text == "Acoustic Grand Piano"
@test string(e) == """MIDI.TrackNameEvent(0, 0x03, "Acoustic Grand Piano")"""

notes_in_track2 = getnotes(track, 2)
@test notes_in_track2.tpq == 2

last_note = last(notes_in_track2)
@test metric_time(midi, last_note) == 226_279.54545454547
@test duration_metric_time(midi, last_note) == 279.54545454545456

@test tempochanges(midi)[1] == (0, 120.0)

# Return the QPM (quarter notes per minute) where the given MIDIFile was exported at. Returns 120 if not found.
@test qpm(midi) == 120.0

# Return how many milliseconds is one tick, based on the quarter notes per minute qpm and ticks per quarter note tpq.
@test ms_per_tick(midi) == 2.272727272727273
# tpq : ticks per quarter notes

# Return the BPM where the given MIDIFile was exported at. Returns QPM if not found.
@test bpm(midi) == 120.0

end # @useinside Main module test_midi_tracks
