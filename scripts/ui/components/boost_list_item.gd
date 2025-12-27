extends Control

@onready var label: Label = $Panel/Label
@onready var button: Button = $Panel/Button

var boost: String = "N/A"
var price: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = boost
	button.text = "$" + str(price)
	if GameManager.boosts.has(boost):
		button.disabled = true
		button.text = "SOLD"

func _on_button_pressed() -> void:
	if GameManager.money < price:
		return
	GameManager.money_updated.emit(GameManager.money, GameManager.money - price, "Bought boost")
	GameManager.boost_bought.emit(boost)
	button.disabled = true
	button.text = "SOLD"
