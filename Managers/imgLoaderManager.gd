extends Node

@onready var ECheckButton = $Divisor/ECheckButton
@onready var IdLineEdit = $Divisor/IdLineEdit
@onready var SearcIdButton = $Divisor/SearcIdButton
@onready var NombreLineEdit = $Divisor/NombreLineEdit
@onready var ImgLineEdit = $Divisor/ImgLineEdit
@onready var ImporterButton = $Divisor/ImporterButton
@onready var Preview = $Divisor/Preview
@onready var UpdateImgButton = $Divisor/UpdateImgButton
@onready var fileDialog = $Divisor/FileDialog

var id_query : String
var state : bool
var query_att : String
var table : String
var columName : String
var pba

func _on_searc_id_button_pressed() -> void:
	state = ECheckButton.button_pressed
	id_query = IdLineEdit.text
	#false = producto, true = tipo
	if !state:
		query_att = "producto_id=" + str(id_query)
		table = "productos"
		columName = "nombre"
	else:
		query_att = "producto_tipo_id=" + str(id_query)
		table = "producto_tipos"
		columName = "tipo_nombre"
	DbManager.select_query(table, query_att, [columName, "img"])
	NombreLineEdit.text = str(DbManager.db.query_result[0][columName]) #crashea si se sale del rango
	load_image()
	
func load_image():
	if DbManager.db.query_result[0]["img"] == null:
		ImgLineEdit.text = "No hay imagen"
		Preview.texture = null
	else:
		ImgLineEdit.text = "Se encontró una imagen"
		for i in DbManager.db.query_result:
			var image = Image.new()
			image.load_jpg_from_buffer(i.img)
			var texture = ImageTexture.create_from_image(image)
			Preview.texture = texture

func _on_importer_button_pressed() -> void:
	fileDialog.popup()

func _on_file_dialog_file_selected(path: String) -> void:
	var image = Image.new()
	image.load(path)
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	Preview.texture = image_texture
	pba = image_texture.get_image().save_jpg_to_buffer()

func _on_update_img_button_pressed() -> void:
	var img_dict = {
		"img" : pba
	}
	DbManager.update_query(table, query_att, img_dict)
	DbManager.initial_query()
	var parent_node = get_tree().root.get_child(1)
	parent_node.send_msg_to_notif("Actualizado correctamente")
