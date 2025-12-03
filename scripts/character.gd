extends Area3D

var taxi_in_area: bool = false

func _process(_delta: float) -> void:
	if taxi_in_area and GameManager.speed == 0:
		self.queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(GameManager.taxi_group):
		taxi_in_area = true


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group(GameManager.taxi_group):
		taxi_in_area = true
