extends Node

@onready var tabSelec : OptionButton = $TabsNuevoModificar/Editar/DivisorST/Divisor/TableSelector
@onready var nuevo_button: Button = $TabsNuevoModificar/Editar/DivisorST/Atributos/NuevoButton
@onready var lookUpButton : Button = $TabsNuevoModificar/Editar/DivisorST/Divisor/LookupButton
@onready var itemList : ItemList = $TabsNuevoModificar/Editar/DivisorST/Divisor/ScrollContainer/ItemList
@onready var id_line_edit: LineEdit = $TabsNuevoModificar/Editar/DivisorST/Atributos/IdLineEdit
@onready var nombre_line_edit: LineEdit = $TabsNuevoModificar/Editar/DivisorST/Atributos/NombreLineEdit
@onready var descrip_line_edit: LineEdit = $TabsNuevoModificar/Editar/DivisorST/Atributos/DescripLineEdit
@onready var spin_box: SpinBox = $TabsNuevoModificar/Editar/DivisorST/Atributos/SpinBox
@onready var cat_sel_button: OptionButton = $TabsNuevoModificar/Editar/DivisorST/Atributos/CatSelButton
@onready var importer_button: Button = $TabsNuevoModificar/Editar/DivisorST/Atributos/ImporterButton
@onready var update_button: Button = $TabsNuevoModificar/Editar/DivisorST/Atributos/UpdateButton
@onready var preview: TextureRect = $TabsNuevoModificar/Editar/DivisorST/Atributos/Preview
@onready var file_dialog: FileDialog = $TabsNuevoModificar/Editar/DivisorST/Atributos/FileDialog

@onready var ticket_num: SpinBox = $TabsNuevoModificar/Tickets/DivConsTicket/DivBotones/TicketNum
@onready var buscar_ticket_button: Button = $TabsNuevoModificar/Tickets/DivConsTicket/DivBotones/BuscarTicketButton
@onready var datimeeditlabel: Label = $TabsNuevoModificar/Tickets/DivConsTicket/datimeeditlabel
@onready var totaleditlabel: Label = $TabsNuevoModificar/Tickets/DivConsTicket/DivDatos/totaleditlabel
@onready var receivededitlabel: Label = $TabsNuevoModificar/Tickets/DivConsTicket/DivDatos/receivededitlabel
@onready var cambioeditlabel: Label = $TabsNuevoModificar/Tickets/DivConsTicket/DivDatos/cambioeditlabel
@onready var ticket_info: TextEdit = $TabsNuevoModificar/Tickets/DivConsTicket/ScrollContainer/ticketInfo

var loaded_image
var type_selected : int
var is_new : bool = false

func disable_fields():
	itemList.clear()
	is_new = false
	nuevo_button.disabled = true
	id_line_edit.editable = false
	id_line_edit.text = ""
	nombre_line_edit.editable = false
	nombre_line_edit.text = ""
	descrip_line_edit.editable = false
	descrip_line_edit.text = ""
	spin_box.editable = false
	spin_box.value = 0.0
	cat_sel_button.clear()
	cat_sel_button.selected = -1
	cat_sel_button.disabled = true
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
	image.resize(512,512) #tamaño de la imagen
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	preview.texture = image_texture
	loaded_image = image_texture.get_image().save_jpg_to_buffer()
	NotifMessage.send("Imagen cargada en buffer")

func _on_lookup_button_pressed() -> void:
	disable_fields()
	nuevo_button.disabled = false
	match tabSelec.selected:
		0: #tabla productos o secciones
			type_selected = 0
			DbManager.initial_query()
			for i in DbManager.sectionList.size():
				itemList.add_item(DbManager.sectionList[i]["nombre"])
			cat_sel_button.selected = -1
			nombre_line_edit.editable = true
			descrip_line_edit.editable = true
			importer_button.disabled = false
			update_button.disabled = false
		1: #tabla productos_tipos o productos
			type_selected = 1
			DbManager.query_all_products()
			for i in DbManager.allProductList.size():
				itemList.add_item(DbManager.allProductList[i]["nombre"] + " - " + DbManager.allProductList[i]["tipo_nombre"])
			for i in DbManager.dbSectionSize:
				cat_sel_button.add_item(DbManager.sectionList[i]["nombre"])
			nombre_line_edit.editable = true
			spin_box.editable = true
			importer_button.disabled = false
			update_button.disabled = false
			cat_sel_button.disabled = false
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
	nuevo_button.disabled = false
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
			cat_sel_button.selected = int(DbManager.allProductList[index]["producto_id"]) - 1
		2: #modificadores
			id_line_edit.text = str(DbManager.allModsList[index]["modificador_id"])
			nombre_line_edit.text = DbManager.allModsList[index]["nombre"]
			spin_box.value = DbManager.allModsList[index]["ajuste_precio"]
		_:
			NotifMessage.send("Opción no válida")

func _on_importer_button_pressed() -> void:
	file_dialog.popup()

func _on_update_button_pressed() -> void:
	if is_new: #si el producto seleccionado será nuevo
		match type_selected:
			0: #categorias
				if nombre_line_edit.text.is_empty() or descrip_line_edit.text.is_empty(): #hace verificaciones para evitar campos vacios
					NotifMessage.send("Hay campos sin llenar")
					pass
				else:
					var dict = {
						#"producto_id" : int(DbManager.dbSectionSize + 1),
						"nombre" : str(nombre_line_edit.text),
						"descripcion" : str(descrip_line_edit.text),
						"img" : loaded_image
					}
					DbManager.insert_query("productos", dict)
			1: #productos
				if nombre_line_edit.text.is_empty():
					NotifMessage.send("Hay campos sin llenar")
					pass
				else:
					var dict = {
						#"producto_tipo_id" : int(DbManager.allProductList.size() + 1),
						"producto_id" : int(cat_sel_button.selected + 1), # TODO: Cambiar esto, la lógica no asume ids borradas ni fuera de orden
						"tipo_nombre" : str(nombre_line_edit.text),
						"precio_base" : float(spin_box.value),
						"img" : loaded_image
					}
					DbManager.insert_query("producto_tipos", dict)
			2: # modificadores
				if nombre_line_edit.text.is_empty():
					NotifMessage.send("Hay campos sin llenar")
					pass
				else:
					var dict = {
						"nombre" : str(nombre_line_edit.text),
						"ajuste_precio" : float(spin_box.value)
					}
					DbManager.insert_query("modificadores", dict)
		NotifMessage.send("Producto nuevo añadido correctamente")
		_on_lookup_button_pressed()
	else: # si es un update nada más
		match type_selected:
			0: #secciones
				var dict = {
					"nombre" : str(nombre_line_edit.text),
					"descripcion" : str(descrip_line_edit.text),
					"img" : loaded_image
				}
				DbManager.update_query("productos", "producto_id=" + str(id_line_edit.text), dict)
			1: #productos
				var dict = {
					"producto_id" : int(cat_sel_button.selected + 1),
					"tipo_nombre" : str(nombre_line_edit.text),
					"precio_base" : float(spin_box.value),
					"img" : loaded_image
				}
				DbManager.update_query("producto_tipos", "producto_tipo_id=" + str(id_line_edit.text),dict)
			2: #modificadores
				var dict = {
					"nombre" : str(nombre_line_edit.text),
					"ajuste_precio" : float(spin_box.value)
				}
				DbManager.update_query("modificadores", "modificador_id=" + str(id_line_edit.text), dict)
		NotifMessage.send("Actualizado correctamente")
		_on_lookup_button_pressed()

func _on_nuevo_button_pressed() -> void:
	nuevo_button.disabled = true
	id_line_edit.text = "Añadiendo nuevo"
	nombre_line_edit.text = ""
	descrip_line_edit.text = ""
	spin_box.value = 0.0
	preview.texture = null
	itemList.clear()
	is_new = true

func _on_buscar_ticket_button_pressed() -> void:
	ticket_info.clear()
	DbManager.select_ticket(int(ticket_num.value))
	datimeeditlabel.text = str(DbManager.ticketinfo[0]["fecha"])
	totaleditlabel.text = str(DbManager.ticketinfo[0]["total_cobrado"])
	receivededitlabel.text = str(DbManager.ticketinfo[0]["total_recibido"])
	cambioeditlabel.text = str(DbManager.ticketinfo[0]["total_cambio"])
	#intento de conversión a dict
	var ticketStringArray = str_to_var(DbManager.ticketinfo[0]["info"])
	for i in ticketStringArray.size():
		var json = JSON.new()
		var sjson = JSON.stringify(ticketStringArray[i])
		var error = json.parse(sjson)
		if error == OK:
			var data_received = json.data
			var detail : String = ""
			detail += "Producto: " + str(data_received["producto"]) + "\n"
			detail += "De: " + str(data_received["tipo"]) + "\n"
			detail += "Cantidad: " + str(data_received["cantidad"]) + "\n"
			detail += "Modificadores: " + str(data_received["modificadores"]) + "\n"
			detail += "Subtotal: $" + str(data_received["subtotal"]) + "\n"
			detail += "Total: $" + str(data_received["total"]) + "\n"
			ticket_info.text += detail + "------------\n"
		
