extends Node

@onready var tabSelec = $TabsNuevoModificar/Editar/DivisorST/Divisor/TableSelector
@onready var optionSelec = $TabsNuevoModificar/Editar/DivisorST/Atributos/OptionButton
@onready var lookUpButton = $TabsNuevoModificar/Editar/DivisorST/Divisor/LookupButton
@onready var itemList = $TabsNuevoModificar/Editar/DivisorST/Divisor/ScrollContainer/ItemList
@onready var id_line_edit: LineEdit = $TabsNuevoModificar/Editar/DivisorST/Atributos/IdLineEdit
@onready var nombre_line_edit: LineEdit = $TabsNuevoModificar/Editar/DivisorST/Atributos/NombreLineEdit
@onready var descrip_line_edit: LineEdit = $TabsNuevoModificar/Editar/DivisorST/Atributos/DescripLineEdit
@onready var spin_box: SpinBox = $TabsNuevoModificar/Editar/DivisorST/Atributos/SpinBox
@onready var importer_button: Button = $TabsNuevoModificar/Editar/DivisorST/Atributos/ImporterButton
@onready var update_button: Button = $TabsNuevoModificar/Editar/DivisorST/Atributos/UpdateButton
@onready var preview: TextureRect = $TabsNuevoModificar/Editar/DivisorST/Atributos/Preview
@onready var file_dialog: FileDialog = $TabsNuevoModificar/Editar/DivisorST/Atributos/FileDialog

var loaded_image
var type_selected : int

func disable_fields():
	id_line_edit.editable = false
	nombre_line_edit.editable = false
	descrip_line_edit.editable = false
	spin_box.editable = false
	importer_button.disabled = true
	update_button.disabled = true

func load_image():
	if DbManager.db.query_result[0]["img"] == null:
		preview.texture = null
		NotifMessage.send("No se ha cargado una imagen")
	else:
		for i in DbManager.db.query_result:
			var image = Image.new()
			image.load_jpg_from_buffer(i.img)
			var texture = ImageTexture.create_from_image(image)
			preview.texture = texture
			NotifMessage.send("Imagen cargada de manera correcta")

func _on_file_dialog_file_selected(path: String) -> void:
	var image = Image.new()
	image.load(path)
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	preview.texture = image_texture
	loaded_image = image_texture.get_image().save_jpg_to_buffer()

func _on_lookup_button_pressed() -> void:
	disable_fields()
	itemList.clear()
	match tabSelec.selected:
		0: #tabla productos o secciones
			type_selected = 0
			DbManager.initial_query()
			NotifMessage.send("Recibida todas las categorias")
			for i in DbManager.seccionesNombres.size():
				itemList.add_item(DbManager.seccionesNombres[i])
			nombre_line_edit.editable = true
			descrip_line_edit.editable = true
			importer_button.disabled = false
			update_button.disabled = false
		1: #tabla productos_tipos o productos
			type_selected = 1
			DbManager.query_all_products()
			NotifMessage.send("Recibido todos los productos")
			for i in DbManager.todosLosProductos.size():
				itemList.add_item(DbManager.todosLosProductos[i]["nombre"] + " - " + DbManager.todosLosProductos[i]["tipo_nombre"])
			nombre_line_edit.editable = true
			descrip_line_edit.editable = true
			spin_box.editable = true
			importer_button.disabled = false
			update_button.disabled = false
		2: #tabla modificadores
			type_selected = 2
			DbManager.query_all_mods()
			NotifMessage.send("Recibido todos los modificadores")
			for i in DbManager.todosLosMods.size():
				itemList.add_item(DbManager.todosLosMods[i]["nombre"])
			nombre_line_edit.editable = true
			spin_box.editable = true
			update_button.disabled = false
		_:
			NotifMessage.send("Opción no recibida correctamente")

func _on_item_list_item_selected(index: int) -> void:
	pass
