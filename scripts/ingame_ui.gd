extends Control

@onready var speed_label: Label = $Speed

var speed: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	speed_label.text = str(abs(roundi(speed))) + " km/h"
