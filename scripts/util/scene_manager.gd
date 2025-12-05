extends Node

@export var scenes: Dictionary[String, PackedScene]

func call_packed(scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene)

func call_scene(scene: String) -> void:
	if scenes.get(scene):
		call_packed(scenes.get(scene))
