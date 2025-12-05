extends Control

@onready var ui_container: Control = $"UI Container"
@export var settings_packed: PackedScene

var settings_node_name: String = ""

func _process(_delta: float) -> void:
	if self.has_node(settings_node_name):
		ui_container.hide()
	else:
		ui_container.show()
	pass

func _on_play_pressed() -> void:
	SceneManager.call_scene("world")

func _on_settings_pressed() -> void:
	var node = settings_packed.instantiate()
	self.add_child(node)
	settings_node_name = node.name

func _on_quit_pressed() -> void:
	get_tree().quit()
