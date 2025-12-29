extends Node3D

@export var lighting_source: DirectionalLight3D
@export var world_environment: WorldEnvironment

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var brightness = GameManager.daytime_to_brightness(GameManager.time)
	lighting_source.light_energy = brightness
	(world_environment.environment.sky.sky_material as PanoramaSkyMaterial).energy_multiplier = brightness

func _ready() -> void:
	CustomerManager.spawn_customer()
	CustomerManager.spawn_customer()
	CustomerManager.spawn_customer()
	CustomerManager.spawn_customer()
	CustomerManager.spawn_customer()
	CustomerManager.spawn_customer()
	CustomerManager.spawn_customer()
