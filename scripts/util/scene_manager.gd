extends Node

@export var scenes: Dictionary[String, PackedScene]
@onready var transition: ColorRect = $Transition

func call_packed(scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene)

func call_scene(scene: String) -> void:
	if scenes.get(scene):
		GameManager.transition.emit("fwd")
		await get_tree().create_timer(transition.duration).timeout
		call_packed(scenes.get(scene))
		GameManager.transition.emit("rev")
