extends Node

#imports y variables
var value : int = 0
var item_selected : int = 0
var product_selected : int = 0
var mod_selected : int = 0

var dbm = DbManager #connector a la base de datos 

#precargar recursos
@onready var itemsButtons = preload("res://Scenes/ItemButton.tscn")
@onready var itemContainer = $controladorDeInterfaz/Divisor/ColorDeFondoProductos/ContenedorTabs/Ventas/Scroller/Grid

# Se ejecuta una sóla vez
func _ready() -> void:
	var itemButtonInstance = itemsButtons.instantiate()
	itemButtonInstance.init(dbm.nombresProductos[1])
	itemContainer.add_child(itemButtonInstance)
	pass

# Se ejecuta cada frame, reducir funciones que van aquí
func _process(_delta: float) -> void:
	pass
