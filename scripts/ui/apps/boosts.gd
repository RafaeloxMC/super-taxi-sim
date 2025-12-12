extends Control

@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer
@export var boosts: Dictionary[String, int] = {}
@export var boost_list_item: PackedScene = preload("res://scenes/ui/components/boost_list_item.tscn")

func _ready() -> void:
	var keys = boosts.keys()
	keys.sort() # optional: gives a predictable order
	for boost in keys:
		var bli = boost_list_item.instantiate() as Control
		bli.boost = boost
		bli.price = boosts[boost]
		v_box_container.add_child(bli)
