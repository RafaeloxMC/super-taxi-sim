extends Control

@onready var speed_label: Label = $Speed
@onready var money: Label = $Money
@onready var color_rect: ColorRect = $ColorRect
@onready var fps: Label = $FPS
@onready var dialog_box: Panel = $DialogBox
@onready var animated_sprite_2d: AnimatedSprite2D = $DialogBox/AnimatedSprite2D
@onready var dialog_author: Label = $DialogBox/Author
@onready var dialog_content: Label = $DialogBox/Content
@onready var progress_bar: ColorRect = $DialogBox/ProgressBar

var initial_dialog_progress_bar_width: float = 0.0

var dialog_queue: Array[String] = []

var money_changed = preload("res://scenes/ui/money_changed.tscn")
var phone = preload("res://scenes/ui/phone.tscn")

func _ready() -> void:
	color_rect.visible = false
	initial_dialog_progress_bar_width = progress_bar.size.x
	GameManager.speed_trap_triggered.connect(speed_trap_triggered)
	GameManager.money_updated.connect(money_update)
	DialogManager.dialog_called.connect(queue_dialog)
	
func money_update(old: float, new: float, _reason: String) -> void:
	var node = money_changed.instantiate()
	money.add_sibling(node)
	node.amount = new - old
	node.tick()

func _process(_delta: float) -> void:
	speed_label.text = str(abs(roundi(GameManager.speed))) + " km/h (" + str(roundi(GameManager.speed_limit)) + " km/h)"
	if GameManager.speed > GameManager.speed_limit:
		var col = Color(0.965, 0.347, 0.347, 1.0)
		col.s = clamp((GameManager.speed - GameManager.speed_limit) / 100 * 4, 0, 1)
		speed_label.add_theme_color_override("font_color", col)
	else:
		speed_label.add_theme_color_override("font_color", Color(255, 255, 255))
	money.text = "$" + str(roundf(GameManager.money * 100) / 100.0)
	if GameManager.money >= 0:
		money.add_theme_color_override("font_color", Color(10 * 1.0 / 255, 255 * 1.0 / 255, 10 * 1.0 / 255, 200 * 1.0 / 255))
	else:
		money.add_theme_color_override("font_color", Color(240 * 1.0 / 255, 10 * 1.0 / 255, 10 * 1.0 / 255, 200 * 1.0 / 255))
	fps.text = str(roundi(Engine.get_frames_per_second())) + " FPS"
	
	if Input.is_action_just_pressed("phone") && !self.has_node("Phone"):
		var node = phone.instantiate()
		self.add_child(node)

func speed_trap_triggered(_speed: float, _max_allowed: float):
	color_rect.visible = true
	await get_tree().create_timer(0.05).timeout
	color_rect.visible = false

func queue_dialog(author: String, content: String) -> void:
	## todo: implement queue functionality
	self.progress_bar.size.x = initial_dialog_progress_bar_width
	self.dialog_author.text = author
	self.dialog_content.text = content
	self.dialog_box.show()
	if DialogManager.contacts.has(author):
		animated_sprite_2d.sprite_frames = DialogManager.contacts.get(author)
		animated_sprite_2d.play("default")
	else:
		print(author + " not found in contacts")
	dialog_timeout(content.length() * 0.075)
	
func dialog_timeout(time: float) -> void:
	var step_size = 0.01
	var steps = time / step_size
	for i in range(steps):
		await get_tree().create_timer(step_size).timeout
		self.progress_bar.size.x = (initial_dialog_progress_bar_width / steps) * (steps - i)
	self.dialog_box.hide()
	
