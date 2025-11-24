extends RigidBody3D
@onready var car_mesh = $"."
@onready var body_mesh = $Car/Model
@onready var ground_ray = $Car/RayCast3D
@onready var fr: Node3D = $Car/Model/Wheels/fr
@onready var fl: Node3D = $Car/Model/Wheels/fl
var body_tilt = 35
var sphere_offset = Vector3.DOWN
var acceleration = 35.0
var steering = 18.0
var turn_speed = 4.0
var turn_stop_limit = 0.75
var speed_input = 0
var turn_input = 0
	
func _physics_process(delta):
	car_mesh.position = position + sphere_offset
	if ground_ray.is_colliding():
		apply_central_force(-car_mesh.global_transform.basis.z * speed_input)
	
func _process(delta):
	if not ground_ray.is_colliding():
		print("Ground is not colliding!")
		return
	speed_input = Input.get_axis("brake", "accelerate") * acceleration
	turn_input = Input.get_axis("steer_right", "steer_left") * deg_to_rad(steering)
	fr.rotation.y = turn_input
	fl.rotation.y = turn_input
	
	if linear_velocity.length() > turn_stop_limit:
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y, turn_input)
		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis, turn_speed * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
		var t = -turn_input * linear_velocity.length() / body_tilt
		body_mesh.rotation.z = lerp(body_mesh.rotation.z, t, 5.0 * delta)
		if ground_ray.is_colliding():
			var n = ground_ray.get_collision_normal()
			var xform = align_with_y(car_mesh.global_transform, n)
			car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10.0 * delta)

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	return xform.orthonormalized()
