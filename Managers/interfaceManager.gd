extends Node

#precargar recursos
@onready var itemsButtons = preload("res://Scenes/ItemButton.tscn") #los botones para ser seleccionados, llama al nodo
@onready var sectionButtons = preload("res://Scenes/SectionButton.tscn")
@onready var itemContainer = $controladorDeInterfaz/Divisor/ColorDeFondoProductos/ContenedorTabs/Ventas/Scroller/Grid
@onready var itemList = $controladorDeInterfaz/Divisor/ColorDeFondoTicket/DivisorTitulo/ContenedorTicket2/Ticket
@onready var notifPanel = $NotifPanel
@onready var notifPanelText = $NotifPanel/TextoNotif
@onready var notifPanelTimer = $NotifPanel/Timer
@onready var ticketSizeLabel = $controladorDeInterfaz/Divisor/ColorDeFondoTicket/DivisorTitulo/ContenedorTicket/DivisorTicketNumber/TicketNumberLab
@onready var ticketFinalPriceLabel = $controladorDeInterfaz/Divisor/ColorDeFondoTicket/DivisorTitulo/DivisorTotalCobrar/CobroTicketText

var current_ticket : Array = [] #aqui vas a guardar diccionarios de los items

# Se ejecuta una sóla vez
func _ready() -> void:
	reload_item_sections_buttons()
	pass

# Se ejecuta cada frame, reducir funciones que van aquí
func _process(_delta: float) -> void:
	ticketSizeLabel.text = str(DbManager.get_last_created_ticket() + 1) #sacar de aqui, no debe ejecutarse cada frame
	pass

func clear_children_in_itemContainer():
	var children = itemContainer.get_children()
	for child in children:
		child.queue_free()

func reload_item_sections_buttons():
	for i in DbManager.dbSectionSize: #creará un botón por cada sección
		var sectionInstance = sectionButtons.instantiate() #crear una instancia 
		#anade las porpiedades del obeto antes de ser creado 
		sectionInstance.init(DbManager.idsSeccionesProductos[i], DbManager.seccionesNombres[i], DbManager.seccionesDescripciones[i], DbManager.seccionesImg[i])
		itemContainer.add_child(sectionInstance) #anade el btpn como un child al menu
		
		#este es el conector al signal del children cuando el botón es presionado
		sectionInstance.clear_items.connect(clear_children_in_itemContainer)
		sectionInstance.create_section_buttons.connect(reload_item_types_buttons)

func reload_item_types_buttons(section): #aqui deberia haber codigo para limpiar todos los childs nodes
	DbManager.products_in_section_query(section)
	for i in DbManager.dbItemSize: #creara un item por cada id que se haya registrado
		var itemButtonInstance = itemsButtons.instantiate() #crear una instancia 
		#anade las porpiedades del obeto antes de ser creado 
		itemButtonInstance.init(DbManager.seccionesNombres[section-1], DbManager.idsProductos[i], DbManager.nombresProductos[i], DbManager.preciosProductos[i], DbManager.imgsProductos[i])
		itemContainer.add_child(itemButtonInstance) #anade el btpn como un child al menu
		
		itemButtonInstance.sendOptionsSelected.connect(create_item_in_ticket)

func create_item_in_ticket(productBigName, productId, productText, optionsSelected, optionsSelectedNames, optionsSelectedPrices,cantidadSelected, productPrice):
	var modsFinalPrices : float = 0.0
	
	for i in optionsSelectedPrices.size():
		modsFinalPrices = modsFinalPrices + optionsSelectedPrices[i]
	
	var productFinalPrice = cantidadSelected * (productPrice + modsFinalPrices)
	
	var item = { #se crea un diccionario para guardar todo
		"id_producto" : productId,
		"cantidad" : cantidadSelected,
		"nombre_producto" : productBigName,
		"nombre" : productText,
		"modificadores_ids" : optionsSelected,
		"modificadores_nombres" : optionsSelectedNames,
		"modificadores_precios" : optionsSelectedPrices,
		"precio_sin_modificadores" : productPrice,
		"precio_final" : productFinalPrice
	}
	current_ticket.append(item)
	
	add_to_list(item)
	update_final_price()

func add_to_list(inputDict : Dictionary):
	var mods_sin_comillas : String = ""
	for i in inputDict["modificadores_nombres"].size():
		mods_sin_comillas = mods_sin_comillas + str(inputDict["modificadores_nombres"][i]) + ", "

	itemList.add_item("($" + str(inputDict["precio_final"]) + ") " + str(inputDict["cantidad"]) + " x " + str(inputDict["nombre_producto"]) + " - " + str(inputDict["nombre"]) + " [" + mods_sin_comillas + "]")

func update_final_price():
	var calculated_final_price : float = 0.0
	for i in current_ticket.size():
		calculated_final_price = calculated_final_price + float(current_ticket[i]["precio_final"])
	ticketFinalPriceLabel.text = "$" + str(calculated_final_price)

func write_ticket_and_print():
	pass

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

func _on_eliminar_item_pressed() -> void:
	var selected_item = itemList.get_selected_items()[0]
	itemList.remove_item(selected_item)
	current_ticket.remove_at(selected_item)
	update_final_price()
