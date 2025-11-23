extends Control

func _on_play_pressed() -> void:
	SceneManager.call_scene("world")

func _on_settings_pressed() -> void:
	SceneManager.call_scene("settings")

func _on_quit_pressed() -> void:
	get_tree().quit()
