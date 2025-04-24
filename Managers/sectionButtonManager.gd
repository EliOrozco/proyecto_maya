extends Control

var SectionId : int
var SectionText : String
var SectionDesc : float

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
	SectionDescriptionLabel.text = str(SectionDesc)
