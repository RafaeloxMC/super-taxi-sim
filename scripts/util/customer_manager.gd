extends Node

@export var roads_parent_group: String
@export var pickup_character: PackedScene
@export var dropoff_location: PackedScene

var current_customer_pickup_location: Vector3
var current_customer_dropoff_location: Vector3

func spawn_customer() -> void:
	var road = pick_random_road()
	if road == null:
		return
	var pickup_char = pickup_character.instantiate() as Node3D
	pickup_char.position.y = 2
	pickup_char.position.x = 6 if randi_range(0, 1) == 1 else -6
	road.add_child(pickup_char)

func spawn_dropoff(customer: String) -> void:
	var road = pick_random_road()
	if road == null:
		return
	var dropoff_loc = dropoff_location.instantiate() as Node3D
	dropoff_loc.customer = customer
	dropoff_loc.tick()
	dropoff_loc.position.y = 0.5
	dropoff_loc.position.x = 6 if randi_range(0, 1) == 1 else -6
	road.add_child(dropoff_loc)
	self.current_customer_dropoff_location = dropoff_loc.global_position

func pick_random_road() -> Node3D:
	var roads_container = get_tree().get_first_node_in_group(roads_parent_group)
	if !roads_container:
		print("Could not spawn customer: Roads Parent not found!")
		return
	var children = roads_container.get_children()
	children = children.filter(func(c): return !c.has_node("Character"))
	if children.size() == 0:
		print("No empty roads left, returning null.")
		return null
	var child = children[randi_range(0, children.size() - 1)]
	return child
