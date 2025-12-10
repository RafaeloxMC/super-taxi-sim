extends Control

@onready var label: Label = $ScrollContainer/VBoxContainer/Label

func _ready() -> void:
	if GameManager.transactions.size() <= 0:
		label.text = "No transactions found"
		return
	for transaction in GameManager.transactions:
		label.text += ("+" if transaction >= 0 else "-") + "$" + str(abs(int(transaction * 100) / 100.0)).pad_decimals(2) + "\n"
