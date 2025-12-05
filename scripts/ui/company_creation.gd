extends Control

func _on_line_edit_text_changed(new_text: String) -> void:
	GameManager.company_name = new_text
