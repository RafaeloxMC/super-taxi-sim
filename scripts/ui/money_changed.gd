extends Control

@onready var money: Label = $Money

var amount: float = 0.0

func _ready() -> void:
	tick()

func tick() -> void:
	if amount >= 0:
		money.add_theme_color_override("font_color", Color(10 * 1.0 / 255, 255 * 1.0 / 255, 10 * 1.0 / 255, 200 * 1.0 / 255))
	else:
		money.add_theme_color_override("font_color", Color(240 * 1.0 / 255, 10 * 1.0 / 255, 10 * 1.0 / 255, 200 * 1.0 / 255))
	money.text = "$" + str(amount)
