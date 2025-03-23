extends Control

@onready var popupscene : PackedScene = preload("res://Scenes/ModsPopUp.tscn")

func _on_product_button_pressed() -> void:
	var popUpInstance = popupscene.instantiate()
	add_child(popUpInstance)
	print("HOLA, he sido presionado")
