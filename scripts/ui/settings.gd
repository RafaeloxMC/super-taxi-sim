extends Control

@onready var unit: Button = $"UI Container/Buttons/Unit"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_unit_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_setting_1_pressed() -> void:
	GameManager.use_kmh = !GameManager.use_kmh
	_update_unit_text()

func _on_credits_pressed() -> void:
	SceneManager.call_scene("credits")

func _on_back_pressed() -> void:
	self.queue_free()

func _update_unit_text() -> void:
	unit.text = "Unit " + ("km/h" if GameManager.use_kmh else "mi/h")
