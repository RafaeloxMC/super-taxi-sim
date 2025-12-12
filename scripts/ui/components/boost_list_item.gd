extends Control

@onready var label: Label = $Panel/Label
@onready var button: Button = $Panel/Button

var boost: String = "N/A"
var price: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = boost
	button.text = "$" + str(price)

func _on_button_pressed() -> void:
	pass # Replace with function body.
