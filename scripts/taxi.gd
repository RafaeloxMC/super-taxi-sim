extends CharacterBody3D

@export var acceleration: float = 20.0
@export var max_speed: float = 15.0
@export var friction: float = 0.1
@export var steer_speed: float = 8.0
@export var steer_limit: float = 1.2
@export var gravity: float = 20.0

@onready var ingame_ui: Control = $Camera3D/IngameUI

var current_speed: float = 0.0
var steer_angle: float = 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var input_forward: float = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var input_turn: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	var target_steer: float = input_turn
	var speed_factor: float = abs(current_speed) / max_speed
	var direction_factor: float = 1.0 if current_speed >= 0.0 else -0.7
	target_steer *= clampf(speed_factor, 0.1, 1.0) * direction_factor
	
	steer_angle = lerp(steer_angle, target_steer * steer_limit, steer_speed * delta)
	rotate_y(steer_angle * delta)
	
	var desired_speed: float = input_forward * max_speed
	current_speed = move_toward(current_speed, desired_speed, acceleration * delta)
	
	if abs(input_forward) < 0.01:
		current_speed = move_toward(current_speed, 0.0, friction * delta)
	
	var forward_direction: Vector3 = -transform.basis.z
	velocity.x = forward_direction.x * current_speed
	velocity.z = forward_direction.z * current_speed
	
	ingame_ui.speed = current_speed
	
	move_and_slide()
