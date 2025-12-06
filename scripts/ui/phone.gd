extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var clock: Label = $Frame/Screen/Wallpaper/Infobar/Clock

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("pull")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("phone"):
		animation_player.play("put")
	clock.text = GameManager.get_time_string(GameManager.time)
