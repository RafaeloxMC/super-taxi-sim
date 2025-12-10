extends ColorRect

@onready var company: Label = $Company
@onready var cname: Label = $Customer/Name

func _ready() -> void:
	company.text = GameManager.company_name
	cname.text = GameManager.customer if GameManager.customer != "" else "None"
