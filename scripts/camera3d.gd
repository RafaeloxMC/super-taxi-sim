extends Camera3D

@export var lerp_speed: float = 8.0
@export var offset: Vector3 = Vector3.ZERO
@export var target: Node3D

@export var clip_margin: float = 0.3
@export var min_distance: float = 0.5
@export var collision_mask: int = 0x7FFFFFFF
@export var pivot_offset: Vector3 = Vector3(0, 2, 0)

func _physics_process(delta: float) -> void:
	if not target:
		return
	
	var target_transform := target.global_transform
	var desired_offset := target_transform.basis * offset
	var desired_position := target_transform.origin + desired_offset
	var ray_from := target.global_position + pivot_offset
	var ray_to := desired_position
	var space := get_world_3d().direct_space_state
	var exclude := [target, self]
	var params = PhysicsRayQueryParameters3D.create(ray_from, ray_to, collision_mask, exclude)
	var hit := space.intersect_ray(params)
	var final_position := desired_position
	if hit:
		var dir: Vector3 = ray_to - ray_from
		if dir.length() > 0.001:
			var safe_pos: Vector3 = hit.position - dir.normalized() * clip_margin
			var dist: float = safe_pos.distance_to(ray_from)
			if dist < min_distance:
				safe_pos = ray_from + dir.normalized() * min_distance
			final_position = safe_pos
	global_position = global_position.lerp(final_position, lerp_speed * delta)
	look_at(ray_from, Vector3.UP)
