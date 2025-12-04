extends Area3D

var taxi: bool

func _process(_delta: float) -> void:
	var isDropoffReady: bool = false
	if GameManager.customer != "":
		isDropoffReady = true
	self.visible = isDropoffReady
	if taxi && GameManager.speed <= 0:
		GameManager.customer = ""
		self.queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(GameManager.taxi_group) && GameManager.customer != "":
		taxi = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group(GameManager.taxi_group):
		taxi = false
