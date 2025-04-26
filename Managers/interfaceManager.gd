extends Node

#precargar recursos
@onready var itemsButtons = preload("res://Scenes/ItemButton.tscn") #los botones para ser seleccionados, llama al nodo
@onready var sectionButtons = preload("res://Scenes/SectionButton.tscn")
@onready var itemContainer = $controladorDeInterfaz/Divisor/ColorDeFondoProductos/ContenedorTabs/Ventas/Scroller/Grid
@onready var itemList = $controladorDeInterfaz/Divisor/ColorDeFondoTicket/DivisorTitulo/ContenedorTicket2/Ticket
@onready var notifPanel = $NotifPanel
@onready var notifPanelText = $NotifPanel/TextoNotif
@onready var notifPanelTimer = $NotifPanel/Timer

# Se ejecuta una sóla vez
func _ready() -> void:
	reload_item_sections_buttons()
	pass

# Se ejecuta cada frame, reducir funciones que van aquí
func _process(_delta: float) -> void:
	pass

func clear_children_in_itemContainer():
	var children = itemContainer.get_children()
	for child in children:
		child.queue_free()

func reload_item_sections_buttons():
	for i in DbManager.dbSectionSize: #creará un botón por cada sección
		var sectionInstance = sectionButtons.instantiate() #crear una instancia 
		#anade las porpiedades del obeto antes de ser creado 
		sectionInstance.init(DbManager.idsSeccionesProductos[i], DbManager.seccionesNombres[i], DbManager.seccionesDescripciones[i])
		itemContainer.add_child(sectionInstance) #anade el btpn como un child al menu
		
		#este es el conector al signal del children cuando el botón es presionado
		sectionInstance.clear_items.connect(clear_children_in_itemContainer)
		sectionInstance.create_section_buttons.connect(reload_item_types_buttons)

func reload_item_types_buttons(section): #aqui deberia haber codigo para limpiar todos los childs nodes
	DbManager.products_in_section_query(section)
	for i in DbManager.dbItemSize: #creara un item por cada id que se haya registrado
		var itemButtonInstance = itemsButtons.instantiate() #crear una instancia 
		#anade las porpiedades del obeto antes de ser creado 
		itemButtonInstance.init(DbManager.idsProductos[i], DbManager.nombresProductos[i], DbManager.preciosProductos[i])
		itemContainer.add_child(itemButtonInstance) #anade el btpn como un child al menu
		
		itemButtonInstance.sendOptionsSelected.connect(create_item_in_ticket)

func create_item_in_ticket(productId, productText, optionsSelected, optionsSelectedNames, optionsSelectedPrices,cantidadSelected, productPrice):
	DbManager.create_ticket_items(productId,cantidadSelected,productPrice)
	for i in optionsSelected:
		DbManager.create_mod_in_ticket_item(i,i)
	itemList.add_item(str(productId, productText, optionsSelected, optionsSelectedNames, optionsSelectedPrices,cantidadSelected, productPrice))

func _on_volver_pressed() -> void:
	clear_children_in_itemContainer()
	reload_item_sections_buttons()
	DbManager.clear_section_queries()

func send_msg_to_notif(notiftext : String):
	notifPanelText.text = notiftext
	notifPanel.visible = true
	notifPanelTimer.start()

func _on_timer_timeout() -> void:
	notifPanelText.text = ""
	notifPanel.visible = false
