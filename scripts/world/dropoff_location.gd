extends Area3D

var taxi_body: Node3D

func _process(_delta: float) -> void:
	var is_dropoff_ready: bool = false
	if GameManager.customer != "":
		is_dropoff_ready = true
	self.visible = is_dropoff_ready
	if is_dropoff_ready && taxi_body && self.overlaps_body(taxi_body) && GameManager.speed <= 0:
		var driven_km = 1
		# driven_km is a placeholder atm
		GameManager.money_updated.emit(GameManager.money, GameManager.money + (GameManager.taxi_base_price * driven_km), "Customer " + GameManager.customer)
		GameManager.customer = ""
		self.queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(GameManager.taxi_group) && GameManager.customer != "":
		taxi_body = body
