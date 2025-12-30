extends ColorRect

@onready var play_pause: Button = $SongDisplay/SongControls/PlayPause
@onready var song_name: Label = $SongDisplay/SongName
@onready var song_artist: Label = $SongDisplay/SongArtist
@onready var cover: TextureRect = $SongDisplay/Cover

var default_cover

func _ready() -> void:
	default_cover = cover.texture
	if MusicManager.is_playing():
		play_pause.text = "Pause"
	else:
		play_pause.text = "Play"

func _process(_delta: float) -> void:
	if song_name.text == MusicManager.current_song.name:
		return
		
	if MusicManager.current_song.name:
		song_name.text = MusicManager.current_song.name
	else:
		song_name.text = "Unknown"
		
	if MusicManager.current_song.artist:
		song_artist.text = MusicManager.current_song.artist
	else:
		song_artist.text = "Unknown"
		
	if MusicManager.current_song.cover:
		cover.texture = MusicManager.current_song.cover
	else:
		cover.texture = default_cover

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
