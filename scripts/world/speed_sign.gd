extends Area3D

@onready var speed_limit_label: Label3D = $StaticBody3D/Model/SpeedLimit

@export var speed_limit: int = 40

func _ready() -> void:
	speed_limit_label.text = str(speed_limit)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(GameManager.taxi_group):
		GameManager.speed_limit = speed_limit
