extends CSGCylinder3D

@export var turn_speed: float = 0.5

func _process(delta: float) -> void:
	self.rotate_y(turn_speed * delta)
