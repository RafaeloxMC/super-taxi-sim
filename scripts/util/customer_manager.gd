extends Node

@export var roads_parent_group: String
@export var pickup_character: PackedScene
@export var dropoff_location: PackedScene

func spawn_customer() -> void:
	var road = pick_random_road()
	var pickup_char = pickup_character.instantiate() as Node3D
	pickup_char.position.y = 2
	pickup_char.position.x = 6 if randi_range(0, 1) == 1 else -6
	road.add_child(pickup_char)
	pass

func spawn_dropoff(customer: String) -> void:
	var road = pick_random_road()
	var dropoff_loc = dropoff_location.instantiate() as Node3D
	dropoff_loc.customer = customer
	dropoff_loc.tick()
	dropoff_loc.position.y = 0.5
	dropoff_loc.position.x = 6 if randi_range(0, 1) == 1 else -6
	road.add_child(dropoff_loc)
	pass

func pick_random_road() -> Node3D:
	var roads_container = get_tree().get_first_node_in_group(roads_parent_group)
	if !roads_container:
		print("Could not spawn customer: Roads Parent not found!")
		return
	var children = roads_container.get_children()
	var child = children[randi_range(0, children.size() - 1)]
	return child
