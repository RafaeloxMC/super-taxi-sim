extends Node

var taxi_group = "TAXI"

var company_name = "Crazy Taxis Co."

var speed: float = 0
var money: float = 100.0
var taxi_base_price: float = 25.0

var speed_trap_fine_base = 5.0

var transactions: Array[float] = []

var names: Array[String] = ["John", "Jane", "Walter", "Max", "Mary", "Marc", "Mike", "Patrick"]
var surnames: Array[String] = ["Star", "White", "Meyers", "Speed", "Brown"]
var customer: String = ""

signal money_updated(before: float, new: float)
signal speed_trap_triggered(speed: float, max_allowed: float)
@warning_ignore("unused_signal")
signal death()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed_trap_triggered.connect(speed_trap_handler)
	money_updated.connect(money_update)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func speed_trap_handler(_speed: float, max_allowed: float):
	var delta = speed - max_allowed
	var cash = money
	money_updated.emit(cash, cash - (speed_trap_fine_base * (delta / 1.5)))
	
@warning_ignore("unused_parameter")
func money_update(before: float, new: float):
	money = new
	transactions.append(new - before)
	print("NEW MONEY UPDATE! $" + str(new))
	
func generate_random_name() -> String:
	var first_name = names.pick_random()
	var surname = surnames.pick_random()
	return first_name + " " + surname
