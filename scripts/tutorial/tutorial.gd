extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CustomerManager.customer_dropped_off.connect(_dropped_off)
	CustomerManager.customer_picked_up.connect(_picked_up)
	CustomerManager.spawn_customer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _dropped_off(name: String, location: Vector3) -> void:
	pass
	
func _picked_up(name: String, location: Vector3) -> void:
	var dialog = "Woah, " + name + ", that's our first customer! Let's bring them to the place they want to go to!"
	DialogManager.call_dialog(name, dialog)
