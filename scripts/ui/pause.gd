extends Control

@onready var ui_container: Control = $"UI Container"

@export var settings_packed: PackedScene

var settings_node_name: String = ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if self.has_node(settings_node_name):
		ui_container.hide()
	else:
		ui_container.show()
	
	if Input.is_action_just_pressed("pause"):
		self.visible = !self.visible
		get_tree().paused = self.visible
		
func _on_resume_pressed() -> void:
	self.visible = false
	get_tree().paused = false
	
func _on_settings_pressed() -> void:
	var node = settings_packed.instantiate()
	self.add_child(node)
	settings_node_name = node.name

func _on_title_screen_pressed() -> void:
	get_tree().paused = false
	SceneManager.call_scene("main_menu")
