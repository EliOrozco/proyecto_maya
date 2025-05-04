extends Control

#señales
signal clear_items
signal create_section_buttons(section)

var SectionId : int
var SectionText : String
var SectionDesc : String
var SectionImg #que tipo de data types es?

var SectionNameLabel : RichTextLabel 
var SectionDescriptionLabel : RichTextLabel
var SectionImgSprite : Sprite2D

var indexName : String

func init(inputDict : Dictionary) -> void: #los atrubutos se asignan antes de ser creados
	#se deben añadir parametros para mandar al popup y la imagen
	SectionId = int(inputDict["producto_id"])
	SectionText = inputDict["nombre"]
	indexName = SectionText.to_lower()
	SectionDesc = str(inputDict["descripcion"])
	SectionImg = load_image(inputDict["img"])
	
	SectionNameLabel = $SectionName #declaracion de la tag, no se puede precargar, tiene que ir en el init
	SectionNameLabel.text = SectionText #manda el texto al display del tag
	SectionDescriptionLabel = $SectionDescription
	SectionDescriptionLabel.text = SectionDesc
	SectionImgSprite = $SectionImage
	SectionImgSprite.texture = SectionImg

func _on_section_button_pressed() -> void:
	clear_items.emit()
	create_section_buttons.emit(SectionId)
	pass # Replace with function body.
	
func load_image(bytearray):
	if bytearray == null:
		NotifMessage.send(SectionText + "no tiene imagen")
	else:
		var image = Image.new()
		image.load_jpg_from_buffer(bytearray)
		var texture = ImageTexture.create_from_image(image)
		return texture
