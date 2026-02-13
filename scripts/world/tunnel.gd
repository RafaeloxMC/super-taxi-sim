extends StaticBody3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("TAXI") && SceneManager.scene_history[SceneManager.scene_history.size() - 1] == SceneManager.scenes.get("tutorial"):
		SceneManager.call_scene("world")
