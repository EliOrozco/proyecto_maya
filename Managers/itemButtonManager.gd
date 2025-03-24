extends Control

@onready var popupscene : PackedScene = preload("res://Scenes/ModsPopUp.tscn")


func init(productText : String) -> void:
	var productNameLabel = $ProductName
	productNameLabel.text = productText

func _on_product_button_pressed() -> void:
	var popUpInstance = popupscene.instantiate()
	add_child(popUpInstance)
	print("HOLA, he sido presionado")
