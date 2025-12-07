extends Node3D

@onready var spot_light_3d: SpotLight3D = $CSGCylinder3D/CSGBox3D/SpotLight3D

func _process(_delta: float) -> void:
	spot_light_3d.visible = false if GameManager.time >= 30000 && GameManager.time <= 60000 else true
