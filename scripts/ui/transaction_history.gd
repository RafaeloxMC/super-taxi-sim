extends Control

@onready var label: Label = $ColorRect/ScrollContainer/VBoxContainer/Label

func _ready() -> void:
	if GameManager.transactions.size() <= 0:
		label.text = "No transactions found"
		return
	for transaction in GameManager.transactions:
		label.text += "$" + str(transaction) + "\n"
