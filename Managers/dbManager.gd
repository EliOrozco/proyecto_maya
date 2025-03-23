extends Node

var db : SQLite

var test = 1

func _ready() -> void:
	db = SQLite.new()
	db.path = "res://database.db"
	db.open_db()
	start()

func start():
	print("Se ha abierto una base de datos aquí -> res://database.db")
