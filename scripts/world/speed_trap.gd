extends StaticBody3D

@onready var flash: SpotLight3D = $speed_trap/SpotLight3D
@onready var area_3d: Area3D = $Area3D

var timeout: float = 0.05
var light_strength: float = 16.0

var triggered: bool = false
var taxi: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flash.light_energy = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !triggered and taxi and area_3d.overlaps_body(taxi):
		if GameManager.speed > GameManager.speed_limit + (GameManager.speed * 0.05):
			triggered = true
			GameManager.speed_trap_triggered.emit(GameManager.speed, float(GameManager.speed_limit))
			flash.light_energy = light_strength
			await get_tree().create_timer(timeout).timeout
			flash.light_energy = 0

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group(GameManager.taxi_group):
		taxi = body

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group(GameManager.taxi_group):
		triggered = false
