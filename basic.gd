extends Node

#imports y variables
var value : int = 0
var item_selected : int = 0
var product_selected : int = 0
var mod_selected : int = 0

@onready var text_notif: RichTextLabel = $textNotif
@onready var text_precio_final: RichTextLabel = $textPrecioFinal
@onready var anadir: Button = $anadir
@onready var eliminar: Button = $eliminar
@onready var modificar: Button = $modificar
@onready var lista_ticket: ItemList = $listaTicket
@onready var lista_producto: ItemList = $listaProducto
@onready var lista_mod: ItemList = $listaMod
@onready var buscador: LineEdit = $buscador

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buscador.grab_focus()

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void: #tiene que emular que ctrl está siendo mantenido presionado
	pass

func _on_button_pressed() -> void: #añadir
	#get text
	var lineEdit_Text : String = buscador.text
	item_selected = lista_producto.get_selected_items()[0]
	mod_selected = lista_mod.get_selected_items()[0]
	
	var item_text = lista_producto.get_item_text(item_selected)
	var mod_text = lista_mod.get_item_text(mod_selected)
	
	if (lineEdit_Text == ""):
		lineEdit_Text = "" + str(value) + item_text + mod_text
	lista_ticket.add_item(lineEdit_Text);
	value += 1
	text_precio_final.text = str(value)
	send_notification("Producto añadido")

func _on_button_2_pressed() -> void: #eliminar
	lista_ticket.select(item_selected - 1)
	lista_ticket.remove_item(item_selected)
	item_selected -= 1
	if (item_selected < 0):
		item_selected = 0
		lista_ticket.select(0)
	send_notification("Producto eliminado correctamente")

func _on_button_3_pressed() -> void: #modificar
	if (lista_ticket.is_anything_selected()):
		item_selected = lista_ticket.get_selected_items()[0] #redundancia
		buscador.text = lista_ticket.get_item_text(item_selected)

func _on_item_list_item_activated(index: int) -> void: #redundacia, este es para clicks doble, no borrar
	pass

func _on_item_list_item_selected(index: int) -> void:
	item_selected = lista_ticket.get_selected_items()[0]

func send_notification(notif: String):
	text_notif.text = notif
