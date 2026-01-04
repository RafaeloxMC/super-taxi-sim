extends Node

@export var contacts: Dictionary[String, SpriteFrames] = {}

signal dialog_called(author: String, content: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func call_dialog(author: String, content: String) -> void:
	print(author + ": ", content)
	dialog_called.emit(author, content)
