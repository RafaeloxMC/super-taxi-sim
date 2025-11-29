extends Control

@onready var speed_label: Label = $Speed
@onready var money: Label = $Money
@onready var color_rect: ColorRect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.visible = false
	GameManager.speed_trap_triggered.connect(speed_trap_triggered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	speed_label.text = str(abs(roundi(GameManager.speed))) + " km/h"
	money.text = "$" + str(roundf(GameManager.money * 100) / 100.0)

func speed_trap_triggered(_speed: float, _max_allowed: float):
	color_rect.visible = true
	await get_tree().create_timer(0.05).timeout
	color_rect.visible = false
