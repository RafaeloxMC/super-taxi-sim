extends Control

@onready var label: Label = $ScrollContainer/VBoxContainer/Label
@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer

var transaction_labels: Array[Label] = []
var gap = 0

func _ready() -> void:
	if GameManager.transactions.size() <= 0:
		label.text = "No transactions found"
		return
	var i = 0
	label.queue_free()
	for transaction in GameManager.transactions:
		var new_transaction = Label.new()
		var amount_positive = (true if transaction >= 0 else false)
		if amount_positive:
			new_transaction.add_theme_color_override("font_color", Color(10 * 1.0 / 255, 255 * 1.0 / 255, 10 * 1.0 / 255, 200 * 1.0 / 255))
		else:
			new_transaction.add_theme_color_override("font_color", Color(240 * 1.0 / 255, 10 * 1.0 / 255, 10 * 1.0 / 255, 200 * 1.0 / 255))
		new_transaction.text = ("+" if amount_positive else "-") + "$" + str(abs(int(transaction * 100) / 100.0)).pad_decimals(2)
		new_transaction.add_theme_font_size_override("font_size", 10)
		new_transaction.position.y = i * self.size.y + i * gap
		transaction_labels.push_back(new_transaction)
		v_box_container.add_child(new_transaction)
		i += 1
