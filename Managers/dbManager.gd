extends Node

var db : SQLite
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
	print(s)

func initial_query():
	#consultas ids
	select_query("productos", "", ["id"])
	for i in db.query_result.size():
		idsProductos.append(str(db.query_result[i]["id"]))
	
	#consultas precios
	select_query("productos", "", ["precio"])
	for i in db.query_result.size():
		preciosProductos.append(float(db.query_result[i]["precio"]))
	
	#consultas nombres
	select_query("productos", "", ["nombre"])
	for i in db.query_result.size():
		nombresProductos.append(str(db.query_result[i]["nombre"]))
	print(idsProductos)
	print(preciosProductos)
	print(nombresProductos)
	
func select_query(table : String, conditions : String, columns : Array):
	db.select_rows(table, conditions, columns)
