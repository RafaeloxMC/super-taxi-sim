extends Control

@onready var label: Label = $ColorRect/ScrollContainer/VBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.transactions.size() <= 0:
		label.text = "No transactions found"
		return
	for transaction in GameManager.transactions:
		label.text += "$" + str(transaction) + "\n"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
