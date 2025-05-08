extends Node
#básicos de operación
var db : SQLite
var dbItemSize : int = 0
var dbSectionSize : int = 0

#secciones
var sectionList : Array[Dictionary] = []

#tipos de prodctos
var productList : Array[Dictionary] = []
var allProductList : Array[Dictionary] = []

#lista de mods en un tipo
var modsList : Array[int] = []
var allModsList : Array[Dictionary] = []

#info de los mods
var idMod : int
var nombreMod : String
var ajustePrecioMod : float

#tickets!!!
var ticketinfo : Array[Dictionary] = []

func _ready() -> void: #crea un objeto para  acceder a la base de datos y la abre para acceder a esos valores 
	db = SQLite.new()
	db.path = "res://database.db"
	db.open_db()
	db.foreign_keys = false
	db.verbosity_level = 2 #INFO: aumentar en 2 para aumentar impresiones en consola
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
	db.query("SELECT t.producto_tipo_id, t.producto_id, p.nombre, t.tipo_nombre, t.precio_base, t.img FROM producto_tipos t LEFT JOIN productos p ON t.producto_id = p.producto_id ORDER BY t.producto_id;")
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

func create_ticket(datetime : String, info : String, cobrado : float, recibido : float, cambio : float):
	var dict = {
		"fecha" : datetime,
		"info" : info,
		"total_cobrado" : cobrado,
		"total_recibido" : recibido,
		"total_cambio" : cambio
	}
	insert_query("tickets", dict)

func get_last_created_ticket() -> int:
	db.query("SELECT ticket_id from tickets ORDER by ticket_id DESC LIMIT 1;")
	return int(db.query_result[0]["ticket_id"])

func clear_section_queries():
	productList.clear()

func clear_mods_queries():
	modsList.clear()
	
func clear_mod_info():
	idMod = 0
	nombreMod = ""
	ajustePrecioMod = 0.0

func select_ticket(selectedTicket : int):
	ticketinfo.clear()
	var set_condition = "ticket_id=" + str(selectedTicket)
	select_query("tickets", set_condition , ["fecha", "info", "total_cobrado", "total_recibido", "total_cambio"])
	ticketinfo.append(db.query_result[0]) #BUG: Si se realiza una consulta fuera del rango

func select_query(table : String, conditions : String, columns : Array): #anade el preformato para hacer consultas 
	var success = db.select_rows(table, conditions, columns)
	if !success: #TODO: Añadir excepciones de consulta
		NotifMessage.send("No se pudo realizar una selección")
		pass

func insert_query(table : String, dict : Dictionary):
	db.insert_row(table, dict) #TODO: Añadir excepciones de consulta
	
func update_query(table : String, conditions : String, dict : Dictionary):
	db.update_rows(table,conditions,dict) #TODO: Añadir excepciones de consulta
