extends RigidBody3D

var sphere_offset = Vector3(0, +0.0206, 0)
var vmax = 150.0
var acceleration = 35.0
var steering = 19.0
var turn_speed = 4.0
var turn_stop_limit = 0.75
var body_tilt = 35
var speed_input = 0
var turn_input = 0
var smoothed = 0
var wheel_step = 0.01

var boost_duration: float = 5.0
var boosted: bool = false
var boost_velocity_multiplier: float = 1.5

@onready var car_mesh: Node3D = $Car
@onready var body_mesh: Node3D = $Car/Model
@onready var ground_ray: RayCast3D = $Car/RayCast3D
@onready var right_wheel: Node3D = $Car/Model/Wheels/fr
@onready var left_wheel: Node3D = $Car/Model/Wheels/fl
@onready var right_wheelb: Node3D = $Car/Model/Wheels/br
@onready var left_wheelb: Node3D = $Car/Model/Wheels/bl
@onready var boost: Node3D = $Car/Model/Boost

var pos = Vector3.ZERO

func _ready():
	lock_rotation = true
	pos = self.position
	GameManager.death.connect(death)
	process_mode = Node.PROCESS_MODE_PAUSABLE
	boost.visible = boosted

func _physics_process(delta: float):
	if global_position.is_finite() && delta != 0:
		var gpos = global_position + Vector3.UP * sphere_offset.y
		car_mesh.global_position = gpos
		
		if ground_ray.is_colliding() && self.linear_velocity.length() * 3.6 < (vmax * (boost_velocity_multiplier if boosted else 1.0)):
			var force = -car_mesh.global_transform.basis.z * speed_input
			apply_central_force(force)

func _process(delta: float):
	if Engine.time_scale == 0 || delta == 0:
		return
	var vel: Vector3 = self.linear_velocity
	if not vel.is_finite():
		return
	var speed_mps: float = vel.length()
	GameManager.speed = speed_mps * 3.6
	
	var forward_velocity: float = -linear_velocity.dot(car_mesh.global_transform.basis.z)
	var wheel_rotation_speed: float = forward_velocity * wheel_step * -1

	left_wheel.rotation.x += wheel_rotation_speed
	right_wheel.rotation.x += wheel_rotation_speed
	left_wheelb.rotation.x += wheel_rotation_speed
	right_wheelb.rotation.x += wheel_rotation_speed
	
	if not ground_ray.is_colliding():
		return
	
	speed_input = Input.get_axis("accelerate", "brake") * acceleration * (boost_velocity_multiplier if boosted else 1.0)
	turn_input = Input.get_axis("steer_left", "steer_right") * deg_to_rad(steering) * (1 if speed_input > 0 else -1)
	
	smoothed = lerp(smoothed + 0.0, turn_input, 0.1)
	
	right_wheel.rotation.y = smoothed
	left_wheel.rotation.y = smoothed
	
	if linear_velocity.length() > turn_stop_limit:
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y, turn_input).orthonormalized()
		var slerped = car_mesh.global_transform.basis.slerp(new_basis, turn_speed * delta).orthonormalized()
		car_mesh.global_transform.basis = slerped
		var ortho = car_mesh.global_transform.orthonormalized()
		car_mesh.global_transform = ortho
		
		var t = -turn_input * linear_velocity.length() / body_tilt
		body_mesh.rotation.z = lerp(body_mesh.rotation.z, t, 5.0 * delta)
		
		if ground_ray.is_colliding():
			var n = ground_ray.get_collision_normal()
			var xform = align_with_y(car_mesh.global_transform, n)
			car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10.0 * delta).orthonormalized()

func align_with_y(xform: Transform3D, new_y: Vector3):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	return xform.orthonormalized()

func death() -> void:
	left_wheel.rotation.x = 0
	right_wheel.rotation.x = 0
	left_wheelb.rotation.x = 0
	right_wheelb.rotation.x = 0
	self.position = pos
	self.linear_velocity = Vector3.ZERO

func trigger_boost() -> void:
	boost.show()
	await get_tree().create_timer(boost_duration).timeout
	boost.hide()
	pass
