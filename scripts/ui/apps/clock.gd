extends ColorRect

@onready var time_display: Label = $"Time/Time Display"
@onready var hours_pointer: Sprite2D = $Time/ClockBG/Hours
@onready var minutes_pointer: Sprite2D = $Time/ClockBG/Minutes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	time_display.text = GameManager.get_time_string(GameManager.time)
	# hour = 60 mins
	# 1 circle = 360° => 360/60 = 6
	var input_time = GameManager.time
	var units_per_minute = GameManager.units_per_hour / 60.0
	var hours = int((input_time / GameManager.units_per_hour)) % 12
	var minutes = (fmod(input_time, GameManager.units_per_hour)) / units_per_minute
	hours += minutes / 60
	hours_pointer.rotation_degrees = hours * 30
	minutes_pointer.rotation_degrees = minutes * 6
