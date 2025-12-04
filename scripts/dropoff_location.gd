extends Area3D

var taxi: bool

func _process(_delta: float) -> void:
	var isDropoffReady: bool = false
	if GameManager.customer != "":
		isDropoffReady = true
	self.visible = isDropoffReady
	if taxi && GameManager.speed <= 0:
		GameManager.customer = ""
		var driven_km = 1
		# driven_km is a placeholder atm
		GameManager.money_updated.emit(GameManager.money, GameManager.money + (GameManager.taxi_base_price * driven_km))
		self.queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(GameManager.taxi_group) && GameManager.customer != "":
		taxi = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group(GameManager.taxi_group):
		taxi = false
