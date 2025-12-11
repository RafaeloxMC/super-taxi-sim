extends Control

@onready var app_container: ColorRect = $"Frame/Screen/Wallpaper/App Container"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var clock: Label = $Frame/Screen/Wallpaper/Infobar/Clock

@export var app: PackedScene

func _ready() -> void:
	var wrapper := Control.new()
	wrapper.name = "RotatedWrapper"
	wrapper.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	app_container.add_child(wrapper)

	var node := app.instantiate() as Control
	node.z_index = 100

	node.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	wrapper.add_child(node)

	await get_tree().process_frame

	var W := wrapper.size.x
	var H := wrapper.size.y

	var target_size := Vector2(H, W)
	node.size = target_size

	node.position = Vector2((W - target_size.x) * 0.5, (H - target_size.y) * 0.5)

	node.pivot_offset = target_size * 0.5
	node.rotation_degrees = 90

func _process(_delta: float) -> void:
	clock.text = GameManager.get_time_string(GameManager.time)

func close(phone: Control):
	animation_player.play_backwards("slide")
	await get_tree().create_timer(0.25).timeout
	phone.show()
	self.queue_free()
