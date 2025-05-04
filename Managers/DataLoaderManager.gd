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
	id_line_edit.text = ""
	nombre_line_edit.editable = false
	nombre_line_edit.text = ""
	descrip_line_edit.editable = false
	descrip_line_edit.text = ""
	spin_box.editable = false
	spin_box.value = 0.0
	preview.texture = null
	importer_button.disabled = true
	update_button.disabled = true
	loaded_image = null

func load_image(bytearray):
	if bytearray == null:
		NotifMessage.send("No se ha cargado una imagen")
	else:
		var image = Image.new()
		image.load_jpg_from_buffer(bytearray)
		var texture = ImageTexture.create_from_image(image)
		return texture

func _on_file_dialog_file_selected(path: String) -> void:
	var image = Image.new()
	image.load(path)
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	preview.texture = image_texture
	loaded_image = image_texture.get_image().save_jpg_to_buffer()
	NotifMessage.send("Imagen cargada en buffer")

func _on_lookup_button_pressed() -> void:
	disable_fields()
	itemList.clear()
	match tabSelec.selected:
		0: #tabla productos o secciones
			type_selected = 0
			DbManager.initial_query()
			for i in DbManager.sectionList.size():
				itemList.add_item(DbManager.sectionList[i]["nombre"])
			nombre_line_edit.editable = true
			descrip_line_edit.editable = true
			importer_button.disabled = false
			update_button.disabled = false
		1: #tabla productos_tipos o productos
			type_selected = 1
			DbManager.query_all_products()
			for i in DbManager.allProductList.size():
				itemList.add_item(DbManager.allProductList[i]["nombre"] + " - " + DbManager.allProductList[i]["tipo_nombre"])
			nombre_line_edit.editable = true
			spin_box.editable = true
			importer_button.disabled = false
			update_button.disabled = false
		2: #tabla modificadores
			type_selected = 2
			DbManager.query_all_mods()
			for i in DbManager.allModsList.size():
				itemList.add_item(DbManager.allModsList[i]["nombre"])
			nombre_line_edit.editable = true
			spin_box.editable = true
			update_button.disabled = false
		_:
			NotifMessage.send("Opción no recibida correctamente")

func _on_item_list_item_selected(index: int) -> void:
	match type_selected:
		0: #secciones
			id_line_edit.text = str(DbManager.sectionList[index]["producto_id"])
			nombre_line_edit.text = DbManager.sectionList[index]["nombre"]
			descrip_line_edit.text = str(DbManager.sectionList[index]["descripcion"])
			preview.texture = load_image(DbManager.sectionList[index]["img"])
			loaded_image = DbManager.sectionList[index]["img"] #se hace para mantener el buffer si ya tenia una imagen en la base de datos
		1: #productos
			id_line_edit.text = str(DbManager.allProductList[index]["producto_tipo_id"])
			nombre_line_edit.text = DbManager.allProductList[index]["tipo_nombre"]
			spin_box.value = DbManager.allProductList[index]["precio_base"]
			preview.texture = load_image(DbManager.allProductList[index]["img"])
			loaded_image = DbManager.allProductList[index]["img"]
		2: #modificadores
			id_line_edit.text = str(DbManager.allModsList[index]["modificador_id"])
			nombre_line_edit.text = DbManager.allModsList[index]["nombre"]
			spin_box.value = DbManager.allModsList[index]["ajuste_precio"]
		_:
			NotifMessage.send("Opción no válida")

func _on_importer_button_pressed() -> void:
	file_dialog.popup()

func _on_update_button_pressed() -> void:
	match type_selected:
		0: #secciones
			var dict = {
				"nombre" = str(nombre_line_edit.text),
				"descripcion" = str(descrip_line_edit.text),
				"img" = loaded_image
			}
			DbManager.update_query("productos", "producto_id=" + str(id_line_edit.text), dict)
			_on_lookup_button_pressed()
		1: #productos
			var dict = {
				"tipo_nombre" = str(nombre_line_edit.text),
				"precio_base" = float(spin_box.value),
				"img" = loaded_image
			}
			DbManager.update_query("producto_tipos", "producto_tipo_id=" + str(id_line_edit.text),dict)
			_on_lookup_button_pressed()
		2: #modificadores
			var dict = {
				"nombre" = str(nombre_line_edit.text),
				"ajuste_precio" = float(spin_box.value)
			}
			DbManager.update_query("modificadores", "modificador_id=" + str(id_line_edit.text), dict)
			_on_lookup_button_pressed()
	NotifMessage.send("Actualizado correctamente")
