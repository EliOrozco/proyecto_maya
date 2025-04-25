extends Node
#básicos de operación
var db : SQLite
var dbItemSize : int = 0
var dbSectionSize : int = 0

#secciones
var idsSeccionesProductos : Array = []
var seccionesNombres : Array = []
var seccionesDescripciones : Array = []

#tipos de prodctos
var idsProductos : Array = []
var nombresProductos : Array = []
var preciosProductos : Array = []

#lista de mods en un tipo
var modsList : Array = []

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
	#consulta ids secciones, nombres y descripciones
	select_query("productos", "", ["producto_id","nombre","descripcion"])
	dbSectionSize = int(db.query_result.size()) #determina el tamaño de la consulta para futuras referencias
	for i in dbSectionSize:
		idsSeccionesProductos.append(int(db.query_result[i]["producto_id"]))
		seccionesNombres.append(str(db.query_result[i]["nombre"]))
		seccionesDescripciones.append(str(db.query_result[i]["descripcion"]))

func products_in_section_query(sectionVarQuery : int): #TODO Limpiar consultas
	var sectionVar : int = sectionVarQuery
	var set_condition : String = "producto_id=" + str(sectionVar)
	
	#consultas ids de tipos
	select_query("producto_tipos", set_condition, ["producto_tipo_id","precio_base","tipo_nombre"])
	dbItemSize = int(db.query_result.size()) #sirve para determinar la cantidad de productos en la base de datos
	for i in dbItemSize:
		idsProductos.append(int(db.query_result[i]["producto_tipo_id"])) #se ñaden a una lista
		preciosProductos.append(float(db.query_result[i]["precio_base"]))
		nombresProductos.append(str(db.query_result[i]["tipo_nombre"]))

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
		"precioBase" : precioBaseQuery,
		"precioTotal" : cantidadQuery * precioBaseQuery
	}
	insert_query("ticket_items", data_dict)
	
func create_ticket_item_mod():
	pass

func get_last_created_ticket() -> int:
	return int(db.query("SELECT ticket_id from tickets ORDER by ticket_id DESC LIMIT 1;"))

func clear_section_queries():
	idsProductos.clear()
	nombresProductos.clear()
	preciosProductos.clear()

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
