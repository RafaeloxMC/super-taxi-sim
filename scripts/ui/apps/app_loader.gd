extends Control

@onready var app_container: ColorRect = $"Frame/Screen/Wallpaper/App Container"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var app: Control

func _ready() -> void:
	app_container.replace_by(app)

func close():
	animation_player.play_backwards("slide")
