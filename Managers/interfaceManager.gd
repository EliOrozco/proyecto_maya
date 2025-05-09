extends Node

#precargar recursos
@onready var itemsButtons : PackedScene = preload("res://Scenes/ItemButton.tscn") #los botones para ser seleccionados, llama al nodo
@onready var sectionButtons : PackedScene = preload("res://Scenes/SectionButton.tscn")
@onready var cambioWindow : PackedScene = preload("res://Scenes/cambio.tscn")
@onready var buscador : LineEdit = $controladorDeInterfaz/Divisor/ColorDeFondoProductos/ContenedorTabs/Ventas/Buscador
@onready var scrollContainer : ScrollContainer = $controladorDeInterfaz/Divisor/ColorDeFondoProductos/ContenedorTabs/Consultas/TabsNuevoModificar/Editar/DivisorST/Divisor/ScrollContainer
@onready var itemContainer : GridContainer = $controladorDeInterfaz/Divisor/ColorDeFondoProductos/ContenedorTabs/Ventas/Scroller/Grid
@onready var itemList : ItemList = $controladorDeInterfaz/Divisor/ColorDeFondoTicket/DivisorTitulo/ContenedorTicket2/Ticket
@onready var ticketSizeLabel : RichTextLabel = $controladorDeInterfaz/Divisor/ColorDeFondoTicket/DivisorTitulo/ContenedorTicket/DivisorTicketNumber/TicketNumberLab
@onready var ticketFinalPriceLabel : RichTextLabel = $controladorDeInterfaz/Divisor/ColorDeFondoTicket/DivisorTitulo/DivisorTotalCobrar/CobroTicketText

var current_ticket : Array[Dictionary] = [] #aqui vas a guardar diccionarios de los items
var calculated_final_price : float = 0.0

# Se ejecuta una sóla vez
func _ready() -> void:
	reload_item_sections_buttons()
	ticketSizeLabel.text = "#" + str(DbManager.get_last_created_ticket() + 1) #todavia no se actualiza con el último ticket
	pass

# Se ejecuta cada frame, reducir funciones que van aquí
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("f1"):
		_on_nuevo_ticket_button_pressed()
	if Input.is_action_just_pressed("f12"):
		_on_volver_pressed()
	if Input.is_action_just_pressed("f10"):
		buscador.grab_focus()
	if Input.is_action_just_pressed("ctrl"):
		#necesita seleccionar sólo si es visivle
		var children = itemContainer.get_children()
		for child in children:
			if child.visible == true:
				itemContainer.get_child(child.get_index()).get_child(1).grab_focus()
				return
	pass

func clear_children_in_itemContainer():
	var children = itemContainer.get_children()
	for child in children:
		child.queue_free()

func reload_item_sections_buttons():
	for i in DbManager.dbSectionSize: #creará un botón por cada sección
		var sectionInstance = sectionButtons.instantiate() #crear una instancia 
		#anade las porpiedades del obeto antes de ser creado 
		sectionInstance.init(DbManager.sectionList[i])
		itemContainer.add_child(sectionInstance) #anade el btpn como un child al menu
		
		#este es el conector al signal del children cuando el botón es presionado
		sectionInstance.clear_items.connect(clear_children_in_itemContainer)
		sectionInstance.create_section_buttons.connect(reload_item_types_buttons)

func reload_item_types_buttons(section): #aqui deberia haber codigo para limpiar todos los childs nodes
	DbManager.products_in_section_query(section)
	scrollContainer.scroll_vertical = 0
	for i in DbManager.dbItemSize: #creara un item por cada id que se haya registrado
		var itemButtonInstance = itemsButtons.instantiate() #crear una instancia 
		#anade las porpiedades del obeto antes de ser creado 
		itemButtonInstance.init(DbManager.sectionList[section-1]["nombre"], DbManager.productList[i])
		itemContainer.add_child(itemButtonInstance) #anade el btpn como un child al menu
		
		itemButtonInstance.sendOptionsSelected.connect(create_item_in_ticket)

func create_item_in_ticket(productBigName, _productId, productText, _optionsSelected, optionsSelectedNames, optionsSelectedPrices,cantidadSelected, productPrice):
	buscador.text = ""
	var modsFinalPrices : float = 0.0
	
	for i in optionsSelectedPrices.size():
		modsFinalPrices = modsFinalPrices + optionsSelectedPrices[i]
	
	var productFinalPrice = cantidadSelected * (productPrice + modsFinalPrices)
	
	var item = { #se crea un diccionario para guardar todo
		"producto" : productBigName,
		"tipo" : productText,
		"cantidad" : cantidadSelected,
		"modificadores" : optionsSelectedNames,
		"subtotal" : productPrice,
		"total" : productFinalPrice
	}
	current_ticket.append(item)
	
	add_to_list(item)
	update_final_price()

func add_to_list(inputDict : Dictionary):
	var mods_sin_comillas : String = ""
	for i in inputDict["modificadores"].size():
		mods_sin_comillas = mods_sin_comillas + str(inputDict["modificadores"][i]) + ", "

	itemList.add_item("($" + str(inputDict["total"]) + ") " + str(inputDict["cantidad"]) + " x " + str(inputDict["producto"]) + " - " + str(inputDict["tipo"]) + " [" + mods_sin_comillas + "]")

func update_final_price():
	calculated_final_price = 0.0
	for i in current_ticket.size():
		calculated_final_price = calculated_final_price + float(current_ticket[i]["total"])
	ticketFinalPriceLabel.text = "$" + str(calculated_final_price)

func _on_volver_pressed() -> void:
	clear_children_in_itemContainer()
	reload_item_sections_buttons()
	DbManager.clear_section_queries()

func _on_eliminar_item_pressed() -> void:
	if itemList.is_anything_selected():
		var selected_item = itemList.get_selected_items()[0]
		itemList.remove_item(selected_item)
		current_ticket.remove_at(selected_item)
		update_final_price()
	else:
		NotifMessage.send("No hay nada seleccionado")

##DOC
func _on_nuevo_ticket_button_pressed() -> void:
	if current_ticket.is_empty():
		NotifMessage.send("No se puede crear un ticket vacio")
	else:
		var cambioWindowInstance = cambioWindow.instantiate()
		cambioWindowInstance.init(calculated_final_price, current_ticket, int(ticketSizeLabel.text))
		add_child(cambioWindowInstance)
		cambioWindowInstance.clear_ticket_signal.connect(clear_ticket)

func clear_ticket():
	ticketSizeLabel.text = "#" + str(DbManager.get_last_created_ticket() + 1)
	buscador.grab_focus()
	itemList.clear()
	current_ticket.clear()
	clear_children_in_itemContainer()
	reload_item_sections_buttons()
	update_final_price()

func _on_buscador_text_changed(new_text: String) -> void:
	if new_text != "": #el buscador tiene texto
		new_text = new_text.to_lower()
		var children = itemContainer.get_children()
		for child in children:
			if child.indexName.contains(new_text):
				child.visible = true
			else:
				child.visible = false
	else: #el buscador esta vacio
		var children = itemContainer.get_children()
		for child in children:
			child.visible = true
