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

var dialog_queue: Array[Dialog] = []
var current_dialog: Dialog = null
var dialog_running: bool = false
var dialog_timeout_paused: bool = false

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
	speed_label.text = str(abs(roundi(GameManager.speed if GameManager.use_kmh else GameManager.speed * 0.6213712))) + " " + ("km/h" if GameManager.use_kmh else "mi/h") + " (" + str(roundi(GameManager.speed_limit if GameManager.use_kmh else GameManager.speed_limit * 0.6213712)) + " " + ("km/h" if GameManager.use_kmh else "mi/h") + ")"
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

	if not dialog_running:
		tick_dialog()
	
func speed_trap_triggered(_speed: float, _max_allowed: float):
	color_rect.visible = true
	await get_tree().create_timer(0.05).timeout
	color_rect.visible = false

func queue_dialog(author: String, content: String) -> void:
	var dialog = Dialog.new()
	dialog.author = author
	dialog.content = content
	dialog_queue.push_back(dialog)
	
func tick_dialog() -> void:
	if dialog_queue.is_empty():
		return

	current_dialog = dialog_queue[0]
	dialog_running = true
	
	dialog_author.text = current_dialog.author
	dialog_content.text = current_dialog.content
	progress_bar.size.x = initial_dialog_progress_bar_width
	dialog_box.show()
	
	if DialogManager.contacts.has(current_dialog.author):
		animated_sprite_2d.sprite_frames = DialogManager.contacts[current_dialog.author]
		animated_sprite_2d.play("default")
	else:
		animated_sprite_2d.stop()
		
	var time: float = current_dialog.content.length() * 0.075
	dialog_timeout(time)
	
func dialog_timeout(time: float) -> void:
	var step_size: float = 0.01
	var elapsed: float = 0.0

	while elapsed < time:
		var tree = get_tree()
		if tree:
			await tree.create_timer(step_size).timeout
			if !is_inside_tree():
				return
			if current_dialog != dialog_queue[0]:
				return
			if dialog_timeout_paused:
				continue
			elapsed += step_size
			var t: float = elapsed / time
			progress_bar.size.x = lerp(initial_dialog_progress_bar_width, 0.0, t)
	dialog_box.hide()
	dialog_queue.pop_front()
	current_dialog = null
	dialog_running = false

func _on_dialog_box_mouse_entered() -> void:
	dialog_timeout_paused = true

func _on_dialog_box_mouse_exited() -> void:
	dialog_timeout_paused = false
