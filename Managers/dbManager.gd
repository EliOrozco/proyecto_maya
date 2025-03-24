extends Node

var db : SQLite
var dbItemSize : int = 0
var idsProductos : Array = []
var nombresProductos : Array = []
var preciosProductos : Array = []

func _ready() -> void:
	db = SQLite.new()
	db.path = "res://database.db"
	db.open_db()
	console_warning("Se ha abierto una base de datos aquí -> res://database.db")
	initial_query()
	
func console_warning(s):
	print(str(s))

func initial_query(): #query que trae los datos al godot
	#consultas ids
	select_query("productos", "", ["id"])
	dbItemSize = int(db.query_result.size()) #sirve para determinar la cantidad de productos en la base de datos
	for i in db.query_result.size():
		idsProductos.append(int(db.query_result[i]["id"])) #se ñaden a una lista
	
	#consultas precios
	select_query("productos", "", ["precio"])
	for i in db.query_result.size():
		preciosProductos.append(float(db.query_result[i]["precio"]))
	
	#consultas nombres
	select_query("productos", "", ["nombre"])
	for i in db.query_result.size():
		nombresProductos.append(str(db.query_result[i]["nombre"]))
	
func select_query(table : String, conditions : String, columns : Array):
	db.select_rows(table, conditions, columns)
