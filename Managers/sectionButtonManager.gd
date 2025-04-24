extends Control

#señales
signal clear_items
signal create_section_buttons(section)

var SectionId : int
var SectionText : String
var SectionDesc : String

var SectionNameLabel : RichTextLabel 
var SectionDescriptionLabel : RichTextLabel

func init(SectionQueryId : int, SectionQueryText : String, SectionQueryDesc : String) -> void:#los atrubutos se asignan antes de ser creados
	#se deben añadir parametros para mandar al popup y la imagen
	SectionId = SectionQueryId
	SectionText = SectionQueryText
	SectionDesc = SectionQueryDesc
	
	SectionNameLabel = $SectionName #declaracion de la tag, no se puede precargar, tiene que ir en el init
	SectionNameLabel.text = SectionText #manda el texto al display del tag
	SectionDescriptionLabel = $SectionDescription
	SectionDescriptionLabel.text = SectionDesc

func _on_section_button_pressed() -> void:
	clear_items.emit()
	create_section_buttons.emit(SectionId)
	pass # Replace with function body.
