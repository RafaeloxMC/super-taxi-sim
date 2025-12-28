extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player.play()
	process_mode = Node.PROCESS_MODE_ALWAYS

func pause() -> void:
	audio_stream_player.stream_paused = true
	
func resume() -> void:
	audio_stream_player.stream_paused = false
	
func is_playing() -> bool:
	return !audio_stream_player.stream_paused
