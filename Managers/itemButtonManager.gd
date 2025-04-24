extends Control

@onready var popupscene : PackedScene = preload("res://Scenes/ModsPopUp.tscn") #precarga el popup
var productId : int
var productText : String
var productPrice : float
var productMods : Array

var productNameLabel : RichTextLabel 
var productPriceLabel : RichTextLabel

func init(productQueryId : int, productQueryText : String, productQueryBasePrice : float) -> void:#los atrubutos se asignan antes de ser creados
	#se deben añadir parametros para mandar al popup y la imagen
	productId = productQueryId
	productText = productQueryText
	productPrice = productQueryBasePrice
	
	productNameLabel = $ProductName #declaracion de la tag, no se puede precargar, tiene que ir en el init
	productNameLabel.text = productText #manda el texto al display del tag
	productPriceLabel = $ProductBasePrice
	productPriceLabel.text = str(productPrice)

func _on_product_button_pressed() -> void:
	var popUpInstance = popupscene.instantiate()#crea la instancia para ser anadida 
	add_child(popUpInstance)

func aplicar_button_has_been_pressed():
	pass
