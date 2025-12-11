extends ColorRect

@onready var time_display: Label = $"Time/Time Display"
@onready var hours_pointer: Sprite2D = $Time/ClockBG/Hours
@onready var minutes_pointer: Sprite2D = $Time/ClockBG/Minutes

@export var tz_items: Dictionary[int, Label]
@export var timezones: Dictionary[int, String]

var offset = 15

func _process(_delta: float) -> void:
	time_display.text = GameManager.get_time_string(GameManager.time)
	var input_time = GameManager.time
	var units_per_minute = GameManager.units_per_hour / 60.0
	var hours = int((input_time / GameManager.units_per_hour)) % 12
	var minutes = (fmod(input_time, GameManager.units_per_hour)) / units_per_minute
	hours += minutes / 60
	hours_pointer.rotation_degrees = hours * 30
	minutes_pointer.rotation_degrees = minutes * 6
	
	for k in tz_items.keys():
		var v = tz_items.get(k) as Label
		var tz_name = timezones.get(k) as String
		v.text = tz_name + ": " + GameManager.add_hours_to_current_time(k + offset)
