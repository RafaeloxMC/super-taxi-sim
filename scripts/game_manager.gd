extends Node

var taxi_group = "TAXI"

var speed: float = 0
var money: float = 0.0

var speed_trap_fine_base = 5.0

signal money_updated(before: float, new: float)
signal speed_trap_triggered(speed: float, max_allowed: float)
signal death()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed_trap_triggered.connect(speed_trap_handler)
	money_updated.connect(money_update)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func speed_trap_handler(speed: float, max_allowed: float):
	var delta = speed - max_allowed
	money_updated.emit(money, money - (speed_trap_fine_base * (delta / 1.5)))
	
func money_update(before: float, new: float):
	money = new
	print("NEW MONEY UPDATE! $" + str(new))
