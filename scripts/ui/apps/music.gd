extends ColorRect

@onready var play_pause: Button = $SongDisplay/SongControls/PlayPause
@onready var song_name: Label = $SongDisplay/SongName
@onready var song_artist: Label = $SongDisplay/SongArtist

func _ready() -> void:
	if MusicManager.is_playing():
		play_pause.text = "Pause"
	else:
		play_pause.text = "Play"

func _process(_delta: float) -> void:
	song_name.text = MusicManager.current_song.name
	song_artist.text = MusicManager.current_song.artist

func _on_previous_pressed() -> void:
	pass # Replace with function body.

func _on_play_pause_pressed() -> void:
	if MusicManager.is_playing():
		MusicManager.pause()
		play_pause.text = "Play"
	else:
		MusicManager.resume()
		play_pause.text = "Pause"

func _on_next_pressed() -> void:
	pass # Replace with function body.
