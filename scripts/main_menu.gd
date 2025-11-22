extends Control

@export var game_scene: PackedScene

func _on_play_pressed() -> void:
	SceneManager.call_scene(game_scene)

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
