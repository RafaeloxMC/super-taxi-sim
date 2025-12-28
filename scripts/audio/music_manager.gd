extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var songs: Array[Song] = []

var current_song: Song

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if songs.size() > 0:
		play(songs[0])
	audio_stream_player.play()
	process_mode = Node.PROCESS_MODE_ALWAYS

func pause() -> void:
	audio_stream_player.stream_paused = true
	
func resume() -> void:
	audio_stream_player.stream_paused = false
	
func is_playing() -> bool:
	return !audio_stream_player.stream_paused

func play(song: Song) -> void:
	current_song = song
	audio_stream_player.stop()
	audio_stream_player.stream = song.audio_stream
	audio_stream_player.play()
