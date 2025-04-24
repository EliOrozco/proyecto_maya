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

func _ready() -> void: #crea un objeto para  acceder a la base de datos y la abre para acceder a esos valores 
	db = SQLite.new()
	db.path = "res://database.db"
	db.open_db()
	console_warning("Se ha abierto una base de datos aquí -> res://database.db")
	initial_query()
	
func console_warning(s): #imprime texto a consola   
	print(str(s))

func initial_query(): #query que trae los datos al godot
	#consulta ids secciones
	select_query("productos", "", ["producto_id"])
	dbSectionSize = int(db.query_result.size()) #determina el tamaño de la consulta para futuras referencias
	for i in dbSectionSize:
		idsSeccionesProductos.append(int(db.query_result[i]["producto_id"]))
	
	#consulta nombres secciones
	select_query("productos", "", ["nombre"])
	for i in dbSectionSize:
		seccionesNombres.append(str(db.query_result[i]["nombre"]))
		
	#consulta descripciones de las secciones
	select_query("productos", "", ["descripcion"])
	for i in dbSectionSize:
		seccionesDescripciones.append(str(db.query_result[i]["descripcion"]))

func products_in_section_query(sectionVarQuery : int):
	var sectionVar : int = sectionVarQuery
	var set_condition : String = "producto_id=" + str(sectionVar)
	
	#consultas ids de tipos
	select_query("producto_tipos", set_condition, ["producto_tipo_id"])
	dbItemSize = int(db.query_result.size()) #sirve para determinar la cantidad de productos en la base de datos
	for i in dbItemSize:
		idsProductos.append(int(db.query_result[i]["producto_tipo_id"])) #se ñaden a una lista
	
	#consultas precios
	select_query("producto_tipos", set_condition, ["precio_base"]) #sirve para traer los precios de la base de datos 
	for i in dbItemSize:
		preciosProductos.append(float(db.query_result[i]["precio_base"]))
	
	#consultas nombres
	select_query("producto_tipos", set_condition, ["tipo_nombre"]) #sirve para traer los nombres a la base de datos
	for i in dbItemSize:
		nombresProductos.append(str(db.query_result[i]["tipo_nombre"]))

func mods_in_section_query(sectionModsVarQuery : int):
	var sectionModsVar : int = sectionModsVarQuery
	var set_condition : String = "producto_tipo_id=" + str(sectionModsVar)
	select_query("producto_tipo_modificadores", set_condition, ["modificador_id"])
	var modsListSize = int(db.query_result.size())
	for i in modsListSize:
		modsList.append(int(db.query_result[i]["modificador_id"]))

func clear_section_queries():
	idsProductos.clear()
	nombresProductos.clear()
	preciosProductos.clear()
	#modsList.clear()

func clear_mods_queries():
	modsList.clear()

func select_query(table : String, conditions : String, columns : Array): #anade el preformato para hacer consultas 
	db.select_rows(table, conditions, columns)
