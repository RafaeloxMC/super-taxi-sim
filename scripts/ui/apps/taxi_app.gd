extends ColorRect

@onready var company: Label = $Company
@onready var cname: Label = $Customer/Name
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var camera_3d: Camera3D = $SubViewportContainer/SubViewport/Camera3D

func _ready() -> void:
	company.text = GameManager.company_name
	cname.text = GameManager.customer if GameManager.customer != "" else "None"
	sub_viewport.world_3d = get_viewport().world_3d
	camera_3d.current = true
	camera_3d.position = Vector3(75, 150, 15)
	camera_3d.rotation_degrees = Vector3(-90, 0, 0)
