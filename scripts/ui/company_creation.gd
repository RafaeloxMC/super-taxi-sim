extends Control

func _ready() -> void:
	GameManager.company_name = "Crazy Taxis Co."

func _on_line_edit_text_changed(new_text: String) -> void:
	GameManager.company_name = new_text

func _on_button_pressed() -> void:
	SceneManager.call_scene("world")
