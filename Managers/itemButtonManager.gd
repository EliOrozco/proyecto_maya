extends Control

@onready var popupscene : PackedScene = preload("res://Scenes/ModsPopUp.tscn")
var productId : int
var productNameLabel : RichTextLabel

func init(productQueryId : int, productText : String) -> void:#los atrubutos se asignan antes de ser creados
	#se deben añadir parametros para mandar al popup y la imagen
	productId = productQueryId
	productNameLabel = $ProductName
	productNameLabel.text = productText

func _on_product_button_pressed() -> void:
	var popUpInstance = popupscene.instantiate()
	add_child(popUpInstance)

func aplicar_button_has_been_pressed():
	pass
