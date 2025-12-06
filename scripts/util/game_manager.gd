extends Node

var taxi_group = "TAXI"

var company_name = "Crazy Taxis Co."

var speed: float = 0
var money: float = 100.0
var taxi_base_price: float = 25.0

var time: float = 0
var game_speed: float = 1
var day_length: float = 90000.0
var units_per_hour: float = day_length / 24.0

var speed_trap_fine_base = 5.0

var transactions: Array[float] = []

var names: Array[String] = ["John", "Jane", "Walter", "Max", "Mary", "Marc", "Mike", "Patrick"]
var surnames: Array[String] = ["Star", "White", "Meyers", "Speed", "Brown"]
var customer: String = ""

signal money_updated(before: float, new: float)
signal speed_trap_triggered(speed: float, max_allowed: float)
@warning_ignore("unused_signal")
signal death()

func _ready() -> void:
	speed_trap_triggered.connect(speed_trap_handler)
	money_updated.connect(money_update)
	
func _process(delta: float) -> void:
	increment_time(delta)

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
	
func increment_time(delta: float, time_speed: float = 60.0):
	time += delta * time_speed * game_speed
	if time >= day_length:
		time -= day_length
	
func get_time_string(input_time: float) -> String:
	var units_per_minute = units_per_hour / 60.0
	var hours = int(input_time / units_per_hour) % 24
	var minutes = int((fmod(input_time, units_per_hour)) / units_per_minute)
	var period = "AM"
	if hours >= 12:
		period = "PM"
	var hour_12 = hours % 12
	if hour_12 == 0:
		hour_12 = 12
	return "%02d:%02d %s" % [hour_12, minutes, period]
	
func wrapped_distance(a: float, b: float) -> float:
	var diff = abs(a - b)
	if diff > day_length * 0.5:
		diff = day_length - diff
	return diff
	
func daytime_to_brightness(daytime: float, peak_hour: float = 12.0, width_hours: float = 6.0) -> float:
	var peak_time = peak_hour * units_per_hour
	var width = width_hours * units_per_hour
	var d = wrapped_distance(daytime, peak_time)
	var value = 1.0 - (d / width) ** 2
	return clamp(value, 0.0, 1.0)
