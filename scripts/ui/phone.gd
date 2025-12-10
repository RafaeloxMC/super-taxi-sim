extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var clock: Label = $Frame/Screen/Wallpaper/Infobar/Clock

@export var apps: Array[Control] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("pull")
	for app in apps:
		app.mouse_entered.connect(func(): on_entered(app))
		app.mouse_exited.connect(func(): on_exited(app))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("phone"):
		animation_player.play("put")
	clock.text = GameManager.get_time_string(GameManager.time)

func on_entered(app: Control):
	app.scale = Vector2(1.1, 1.1)

func on_exited(app: Control):
	app.scale = Vector2(1, 1)
