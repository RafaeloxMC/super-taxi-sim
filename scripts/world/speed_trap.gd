extends StaticBody3D

@export var speed_limit: int = 50
@onready var flash: SpotLight3D = $speed_trap/SpotLight3D

var timeout: float = 0.05
var light_strength: float = 16.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flash.light_energy = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group(GameManager.taxi_group):
		if GameManager.speed > speed_limit:
			GameManager.speed_trap_triggered.emit(GameManager.speed, float(speed_limit))
			flash.light_energy = light_strength
			await get_tree().create_timer(timeout).timeout
			flash.light_energy = 0
