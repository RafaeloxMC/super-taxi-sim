extends Area3D

var taxi_body: Node3D
var customer: String = ""

func tick() -> void:
	print("Customer: " + customer)

func _process(_delta: float) -> void:
	var is_dropoff_ready: bool = false
	if GameManager.customer != "" && GameManager.customer == customer:
		is_dropoff_ready = true
	self.visible = is_dropoff_ready
	if is_dropoff_ready && taxi_body && self.overlaps_body(taxi_body) && round(GameManager.speed) == 0:
		var from = CustomerManager.current_customer_pickup_location
		from.y = 0
		var to = CustomerManager.current_customer_dropoff_location
		to.y = 0
		var distance = abs(to - from)
		var driven_km = distance.length() / 1000
		var bonus = randf_range(0.5, 5) if GameManager.time_for_customer_bonus - Time.get_unix_time_from_system() > 0.0 else 0.0
		GameManager.money_updated.emit(GameManager.money, GameManager.money + (GameManager.taxi_base_price * driven_km) + (bonus), "Customer " + GameManager.customer)
		CustomerManager.customer_dropped_off.emit(GameManager.customer, self.global_position)
		GameManager.customer = ""
		CustomerManager.spawn_customer()
		self.queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(GameManager.taxi_group) && GameManager.customer != "":
		taxi_body = body
