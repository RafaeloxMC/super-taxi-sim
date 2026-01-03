extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CustomerManager.customer_dropped_off.connect(_dropped_off)
	CustomerManager.customer_picked_up.connect(_picked_up)
	CustomerManager.spawn_customer()

func _dropped_off(_customer_name: String, _location: Vector3) -> void:
	var dialog = "Yo, that was amazing! That's how we do it! Maybe you can be a little faster next time and even get a bonus from the customer!"
	DialogManager.call_dialog("Taxi Central", dialog)
	
func _picked_up(customer_name: String, _location: Vector3) -> void:
	var dialog = "Woah, " + customer_name + ", that's our first customer? Let's bring them to the place they want to go to! Check the taxi app to find the location."
	DialogManager.call_dialog("Taxi Central", dialog)
