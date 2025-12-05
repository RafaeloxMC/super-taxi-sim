extends Control

@onready var speed_label: Label = $Speed
@onready var money: Label = $Money
@onready var color_rect: ColorRect = $ColorRect
@onready var fps: Label = $FPS

var money_changed = preload("res://scenes/ui/money_changed.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.visible = false
	GameManager.speed_trap_triggered.connect(speed_trap_triggered)
	GameManager.money_updated.connect(money_update)
	pass # Replace with function body.

func money_update(old: float, new: float) -> void:
	var node = money_changed.instantiate()
	money.add_sibling(node)
	node.amount = new - old
	node.tick()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	speed_label.text = str(abs(roundi(GameManager.speed))) + " km/h"
	money.text = "$" + str(roundf(GameManager.money * 100) / 100.0)
	if GameManager.money >= 0:
		money.add_theme_color_override("font_color", Color(10 * 1.0 / 255, 255 * 1.0 / 255, 10 * 1.0 / 255, 200 * 1.0 / 255))
	else:
		money.add_theme_color_override("font_color", Color(240 * 1.0 / 255, 10 * 1.0 / 255, 10 * 1.0 / 255, 200 * 1.0 / 255))
	fps.text = str(roundi(Engine.get_frames_per_second())) + " FPS"

func speed_trap_triggered(_speed: float, _max_allowed: float):
	color_rect.visible = true
	await get_tree().create_timer(0.05).timeout
	color_rect.visible = false
