extends Node

#imports y variables
var value : int = 0
var item_selected : int = 0
var product_selected : int = 0
var mod_selected : int = 0

var dbm = DbManager #connector a la base de datos, está siempre cargado, esta es su refenrecnai

#precargar recursos
@onready var itemsButtons = preload("res://Scenes/ItemButton.tscn") #los botones para ser seleccionados, llama al nodo
@onready var itemContainer = $controladorDeInterfaz/Divisor/ColorDeFondoProductos/ContenedorTabs/Ventas/Scroller/Grid
@onready var itemList = $controladorDeInterfaz/Divisor/ColorDeFondoTicket/DivisorTitulo/ContenedorTicket/ItemList

# Se ejecuta una sóla vez
func _ready() -> void:
	reload_item_buttons()
	pass

# Se ejecuta cada frame, reducir funciones que van aquí
func _process(_delta: float) -> void:
	pass

func reload_item_buttons():
	#aqui deberia haber codigo para limpiar todos los childs nodes
	for i in dbm.dbItemSize: #creara un item por cada id que se haya registrado
		var itemButtonInstance = itemsButtons.instantiate()
		itemButtonInstance.init(dbm.idsProductos[i], dbm.nombresProductos[i])
		itemContainer.add_child(itemButtonInstance)

func create_item_in_ticket(t):
	itemList.add_item(str(t))
