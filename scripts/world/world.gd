extends Node3D

@export var lighting_source: DirectionalLight3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var brightness = GameManager.daytime_to_brightness(GameManager.time)
	lighting_source.light_energy = brightness
