extends Node

var dbm = DbManager #connector a la base de datos, está siempre cargado, esta es su refenrecnai

#precargar recursos
@onready var itemsButtons = preload("res://Scenes/ItemButton.tscn") #los botones para ser seleccionados, llama al nodo
@onready var sectionButtons = preload("res://Scenes/SectionButton.tscn")
@onready var itemContainer = $controladorDeInterfaz/Divisor/ColorDeFondoProductos/ContenedorTabs/Ventas/Scroller/Grid
@onready var itemList = $controladorDeInterfaz/Divisor/ColorDeFondoTicket/DivisorTitulo/ContenedorTicket/ItemList

# Se ejecuta una sóla vez
func _ready() -> void:
	reload_item_sections_buttons()
	#reload_item_types_buttons()
	pass

# Se ejecuta cada frame, reducir funciones que van aquí
func _process(_delta: float) -> void:
	pass

func clear_children_in_itemContainer():
	for n in itemContainer:
		itemContainer.remove_child(n)
		n.queue_free()

func reload_item_sections_buttons():
	for i in dbm.dbSectionSize: #creará un botón por cada sección
		var sectionInstance = sectionButtons.instantiate() #crear una instancia 
		#anade las porpiedades del obeto antes de ser creado 
		sectionInstance.init(dbm.idsSeccionesProductos[i], dbm.seccionesProductos[i])
		itemContainer.add_child(sectionInstance) #anade el btpn como un child al menu

func reload_item_types_buttons(): #aqui deberia haber codigo para limpiar todos los childs nodes
	for i in dbm.dbItemSize: #creara un item por cada id que se haya registrado
		var itemButtonInstance = itemsButtons.instantiate() #crear una instancia 
		#anade las porpiedades del obeto antes de ser creado 
		itemButtonInstance.init(dbm.idsProductos[i], dbm.nombresProductos[i], dbm.preciosProductos[i])
		itemContainer.add_child(itemButtonInstance) #anade el btpn como un child al menu

func clear_buttons():
	var lista_childrens : Array = itemContainer.get_children()
	print(lista_childrens)

func create_item_in_ticket(t):
	itemList.add_item(str(t))
