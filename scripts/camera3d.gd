extends Camera3D

@export var lerp_speed: float = 8.0
@export var offset: Vector3 = Vector3.ZERO
@export var target: Node3D

func _physics_process(delta: float) -> void:
	if not target:
		return
	
	var target_transform := target.global_transform
	var desired_offset := target_transform.basis * offset
	var desired_position := target_transform.origin + desired_offset
	
	global_position = global_position.lerp(desired_position, lerp_speed * delta)
	
	look_at(target.global_position + Vector3(0, 2, 0), Vector3.UP)
