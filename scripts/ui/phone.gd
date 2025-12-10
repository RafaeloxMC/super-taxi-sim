extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var clock: Label = $Frame/Screen/Wallpaper/Infobar/Clock

@export var app_handler: PackedScene = preload("res://scenes/ui/apps/app_layout.tscn")
@export var apps: Array[Control] = []
@export var app_screens: Dictionary[String, PackedScene] = {}

var current_app: String = ""
var current_app_node: Node

func _ready() -> void:
	animation_player.play("pull")
	for app in apps:
		app.mouse_entered.connect(func(): on_entered(app))
		app.mouse_exited.connect(func(): on_exited(app))
		app.gui_input.connect(_on_app_clicked.bind(app))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("phone"):
		if current_app != "":
			close_app()
		else:
			animation_player.play("put")
	clock.text = GameManager.get_time_string(GameManager.time)

func on_entered(app: Control):
	app.scale = Vector2(1.1, 1.1)

func on_exited(app: Control):
	app.scale = Vector2(1, 1)
	
func _on_app_clicked(event: InputEvent, app: Control) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		open_app(app.name)
	
func open_app(app: String):
	var screen = app_screens.get(app)
	if not screen:
		print("App " + app + " not found!")
		return
	current_app = app
	var node = app_handler.instantiate()
	node.app = screen
	current_app_node = node
	self.add_sibling(node)
	self.hide()
	print("Opening app " + app + ", corresponding node: " + str(node.app))

func close_app():
	current_app = ""
	current_app_node.close(self)
