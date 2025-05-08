extends Control

signal sendOptionsSelected(productBigName, productId, productText, optionsSelected, optionsSelectedNames, optionsSelectedPrices, cantidadSelected, productPrice)

@onready var popupscene : PackedScene = preload("res://Scenes/ModsPopUp.tscn") #precarga el popup
var productBigName : String
var productId : int
var productText : String
var productPrice : float
var productMods : Array
var productImg #sigo sin saber que data types es

var productNameLabel : RichTextLabel 
var productPriceLabel : RichTextLabel
var productImgSprite : Sprite2D

var indexName : String #el buscador busca lo que sea que esté aqui

func init(productBigNameQuery : String, inputDict : Dictionary) -> void:
	#los atrubutos se asignan antes de ser creados
	productBigName = productBigNameQuery #esto es porque al parecer los tipos no sabían que producto eran lol
	
	#se deben añadir parametros para mandar al popup y la imagen
	productId = inputDict["producto_tipo_id"]
	productText = inputDict["tipo_nombre"]
	indexName = productText.to_lower()
	productPrice = inputDict["precio_base"]
	productImg = load_image(inputDict["img"])
	
	productNameLabel = $ProductName #declaracion de la tag, no se puede precargar, tiene que ir en el init
	productNameLabel.text = productText #manda el texto al display del tag
	productPriceLabel = $ProductBasePrice
	productPriceLabel.text = str(productPrice)
	productImgSprite = $ProductImage
	productImgSprite.texture = productImg

func _on_product_button_pressed() -> void:
	DbManager.mods_in_section_query(productId)
	var popUpInstance = popupscene.instantiate() #crea la instancia para ser anadida 
	add_child(popUpInstance)
	popUpInstance.sendOptionsSelected.connect(send_options_selected_upward)

func send_options_selected_upward(optionsSelected, optionsSelectedNames, optionsSelectedPrices, cantidadSelected):
	sendOptionsSelected.emit(productBigName, productId, productText, optionsSelected, optionsSelectedNames, optionsSelectedPrices,cantidadSelected, productPrice)

func aplicar_button_has_been_pressed():
	pass

func load_image(bytearray):
	if bytearray == null:
		NotifMessage.send(productText + " no tiene imagen")
	else:
		var image = Image.new()
		image.load_jpg_from_buffer(bytearray)
		var texture = ImageTexture.create_from_image(image)
		return texture
