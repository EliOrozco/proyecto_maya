extends Node
#básicos de operación
var db : SQLite
var dbItemSize : int = 0
var dbSectionSize : int = 0

#secciones
var sectionList : Array = []

#tipos de prodctos
var productList : Array = []
var allProductList : Array = []

#lista de mods en un tipo
var modsList : Array = []

var allModsList : Array = []

#info de los mods
var idMod : int
var nombreMod : String
var ajustePrecioMod : float

func _ready() -> void: #crea un objeto para  acceder a la base de datos y la abre para acceder a esos valores 
	db = SQLite.new()
	db.path = "res://database.db"
	db.open_db()
	print("Se ha abierto una base de datos aquí -> res://database.db")
	initial_query()

func initial_query(): #query que trae los datos al godot
	#limpiar registros existentes
	sectionList.clear()
	#consulta ids secciones, nombres y descripciones
	select_query("productos", "", ["producto_id","nombre","descripcion", "img"])
	dbSectionSize = int(db.query_result.size()) #determina el tamaño de la consulta para futuras referencias
	for i in dbSectionSize:
		sectionList.append(db.query_result[i])

func products_in_section_query(sectionVarQuery : int):
	productList.clear()
	
	var sectionVar : int = sectionVarQuery
	var set_condition : String = "producto_id=" + str(sectionVar)
	
	#consultas ids de tipos
	select_query("producto_tipos", set_condition, ["producto_tipo_id","precio_base","tipo_nombre", "img"])
	dbItemSize = int(db.query_result.size()) #sirve para determinar la cantidad de productos en la base de datos
	for i in dbItemSize:
		productList.append(db.query_result[i])

func query_all_products():
	allProductList.clear()
	db.query("SELECT t.producto_tipo_id, t.producto_id, p.nombre, t.tipo_nombre, t.precio_base, t.img FROM producto_tipos t LEFT JOIN productos p ON t.producto_id = p.producto_id;")
	for i in db.query_result.size():
		allProductList.append(db.query_result[i])

func query_all_mods():
	allModsList.clear()
	select_query("modificadores", "", ["modificador_id", "nombre", "ajuste_precio"])
	for i in db.query_result.size():
		allModsList.append(db.query_result[i])
	
func mods_in_section_query(sectionModsVarQuery : int):
	var sectionModsVar : int = sectionModsVarQuery
	var set_condition : String = "producto_tipo_id=" + str(sectionModsVar)
	select_query("producto_tipo_modificadores", set_condition, ["modificador_id"])
	var modsListSize = int(db.query_result.size())
	for i in modsListSize:
		modsList.append(int(db.query_result[i]["modificador_id"]))

func get_mod_info(idModQuery : int):
	idMod = idModQuery
	var set_condition = "modificador_id=" + str(idMod)
	select_query("modificadores", set_condition, ["nombre", "ajuste_precio"])
	
	nombreMod = str(db.query_result[0]["nombre"])
	ajustePrecioMod = float(db.query_result[0]["ajuste_precio"])
	
	if (float(db.query_result[0]["ajuste_precio"]) > 0):
		nombreMod = nombreMod + " (+$" + str(db.query_result[0]["ajuste_precio"]) + ")"

func get_product(idProductQuery):
	var idProduct = idProductQuery
	var set_condition = "modificador_id=" + str(idProduct)
	select_query("modificadores", set_condition, ["nombre", "ajuste_precio"])

func create_ticket():
	var get_time = Time.get_datetime_string_from_system(false, true)
	var data_dict = {
		"fecha" : get_time
	}
	insert_query("tickets", data_dict)

func create_ticket_items(producto_tipo_id_query : int, cantidadQuery : int, precioBaseQuery : float):
	var data_dict = {
		"ticket_id" : get_last_created_ticket(),
		"producto_tipo_id" : producto_tipo_id_query,
		"cantidad" : cantidadQuery,
		"precio_base" : precioBaseQuery,
		"precio_total" : cantidadQuery * precioBaseQuery
	}
	insert_query("ticket_items", data_dict)
	
func create_mod_in_ticket_item(modificador_id_query : int, ajuste_precio_query : float):
	var data_dict = {
		"ticket_item_id" : get_last_created_ticket_item(),
		"modificador_id" : modificador_id_query,
		"ajuste_precio"  : ajuste_precio_query
	}
	insert_query("ticket_item_modificadores", data_dict)

func get_last_created_ticket() -> int:
	db.query("SELECT ticket_id from tickets ORDER by ticket_id DESC LIMIT 1;")
	return int(db.query_result[0]["ticket_id"])
	
func get_last_created_ticket_item() -> int:
	db.query("SELECT ticket_item_id from ticket_items ORDER by ticket_item_id DESC LIMIT 1;")
	return int(db.query_result[0]["ticket_item_id"])

func clear_section_queries():
	productList.clear()

func clear_mods_queries():
	modsList.clear()
	
func clear_mod_info():
	idMod = 0
	nombreMod = ""
	ajustePrecioMod = 0.0

func select_query(table : String, conditions : String, columns : Array): #anade el preformato para hacer consultas 
	db.select_rows(table, conditions, columns)

func insert_query(table : String, dict : Dictionary):
	db.insert_row(table, dict)
	
func update_query(table : String, conditions : String, dict : Dictionary):
	db.update_rows(table,conditions,dict)
