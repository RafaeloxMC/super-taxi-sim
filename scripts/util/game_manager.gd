extends Node

# INTERNAL

var taxi_group = "TAXI"

var company_name = "Crazy Taxis Co."

# Base values
var speed: float = 0
var speed_limit: float = 50.0
var money: float = 100.0
var taxi_base_price: float = 25.0
var speed_trap_fine_base = 5.0
var transactions: Array[Transaction] = []

# Boosts system
var boosts: Array[String] = []

# Time system

var day: int = 1
var time: float = 33750
var game_speed: float = 1
var day_length: float = 90000.0
var units_per_hour: float = day_length / 24.0

var names: Array[String] = ["John", "Jane", "Walter", "Max", "Mary", "Marc", "Mike", "Patrick", "Isaac", "Zach", "Yuno", "Elon", "Yi Long", "Donald", "Bill", "John", "Bruno", "Jack", "Lester", "Olivia", "Ava", "Liam", "Zara", "Francesco"]
var surnames: Array[String] = ["Star", "White", "Meyers", "Speed", "Brown", "Miller", "Latta", "Ma", "Trumpet", "Yates", "Pork", "Saturn", "Sparrow", "Crest", "Clinton", "Bush", "Parker", "Bennet", "Harrison", "Sullivan", "Drake"]
var customer: String = ""

var time_for_customer_bonus: float = 0.0

signal money_updated(before: float, new: float, reason: String)
signal speed_trap_triggered(speed: float, max_allowed: float)
@warning_ignore("unused_signal")
signal death()
@warning_ignore("unused_signal")
signal transition(dir: String)

signal boost_bought(boost: String)
signal taxi_trigger_boost()

func _ready() -> void:
	speed_trap_triggered.connect(speed_trap_handler)
	money_updated.connect(money_update)
	boost_bought.connect(boost_bought_handler)
	
func _process(delta: float) -> void:
	increment_time(delta)

func speed_trap_handler(_speed: float, max_allowed: float):
	var delta = speed - max_allowed
	var cash = money
	if boosts.has("Bribe Cops"):
		speed_trap_fine_base = 2.5
	money_updated.emit(cash, cash - (speed_trap_fine_base * (delta / 1.5)), "Speeding Fine")
	
func boost_bought_handler(boost: String) -> void:
	boosts.append(boost)
	print("Boost bought: " + boost)
	if boost == "Speed Boost":
		taxi_trigger_boost.emit()
	
@warning_ignore("unused_parameter")
func money_update(before: float, new: float, reason: String):
	money = new
	var transaction: Transaction = Transaction.new()
	transaction.amount = new - before
	transaction.reason = reason
	transactions.append(transaction)
	print("NEW MONEY UPDATE! $" + str(new))
	
func generate_random_name() -> String:
	var first_name = names.pick_random()
	var surname = surnames.pick_random()
	return first_name + " " + surname
	
func increment_time(delta: float, time_speed: float = 60.0):
	time += delta * time_speed * game_speed
	if time >= day_length:
		time -= day_length
		day += 1
	
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
	
	
func add_hours_to_current_time(hours_offset: int) -> String:
	var buf = time
	buf += hours_offset * units_per_hour
	buf -= int(buf / day_length) * day_length
	return get_time_string(buf)
	
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
