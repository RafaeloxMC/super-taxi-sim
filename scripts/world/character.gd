extends Area3D

var taxi_body: Node3D

func _process(_delta: float) -> void:
	if taxi_body && self.overlaps_body(taxi_body) and round(GameManager.speed) == 0 && GameManager.customer == "":
		GameManager.customer = GameManager.generate_random_name()
		print("New customer! " + str(GameManager.customer))
		CustomerManager.spawn_dropoff(GameManager.customer)
		CustomerManager.current_customer_pickup_location = self.global_position
		self.queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(GameManager.taxi_group):
		taxi_body = body
