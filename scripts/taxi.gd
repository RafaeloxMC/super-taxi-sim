extends RigidBody3D

var sphere_offset = Vector3(0, +0.1, 0)
var acceleration = 35.0
var steering = 19.0
var turn_speed = 4.0
var turn_stop_limit = 0.75
var body_tilt = 35
var speed_input = 0
var turn_input = 0

var smoothed = 0

@onready var car_mesh = $Car
@onready var body_mesh = $Car/Model
@onready var ground_ray = $Car/RayCast3D
@onready var right_wheel = $Car/Model/Wheels/fr
@onready var left_wheel = $Car/Model/Wheels/fl

func _ready():
	lock_rotation = true

func _physics_process(_delta: float):
	car_mesh.global_position = global_position + Vector3.UP * sphere_offset.y
	
	if ground_ray.is_colliding():
		apply_central_force(-car_mesh.global_transform.basis.z * speed_input)

func _process(delta: float):
	if not ground_ray.is_colliding():
		return
	
	speed_input = Input.get_axis("accelerate", "brake") * acceleration
	turn_input = Input.get_axis("steer_left", "steer_right") * deg_to_rad(steering) * (1 if speed_input > 0 else -1)
	
	smoothed = lerp(smoothed + 0.0, turn_input, 0.1)
	
	right_wheel.rotation.y = smoothed
	left_wheel.rotation.y = smoothed
	
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

func align_with_y(xform: Transform3D, new_y: Vector3):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	return xform.orthonormalized()
