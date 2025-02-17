extends Node

#imports y variables
var value : int = 0
var item_selected : int = 0
var product_selected : int = 0
var mod_selected : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LineEdit.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void: #añadir
	#get text
	var lineEdit_Text : String = $LineEdit.text
	item_selected = $ItemList2.get_selected_items()[0]
	mod_selected = $ItemList3.get_selected_items()[0]
	
	var item_text = $ItemList2.get_item_text(item_selected)
	var mod_text = $ItemList3.get_item_text(mod_selected)
	
	if (lineEdit_Text == ""):
		lineEdit_Text = "Añadido " + str(value) + item_text + mod_text
	$ItemList.add_item(lineEdit_Text);
	value += 1
	$RichTextLabel2.text = str(value)
	send_notification("Producto añadido")


func _on_button_2_pressed() -> void: #eliminar
	$ItemList.select(item_selected - 1)
	$ItemList.remove_item(item_selected)
	item_selected -= 1
	if (item_selected < 0):
		item_selected = 0
		$ItemList.select(0)
	send_notification("Producto eliminado correctamente")

func _on_button_3_pressed() -> void: #modificar
	if ($ItemList.is_anything_selected()):
		item_selected = $ItemList.get_selected_items()[0] #redundancia
		$LineEdit.text = $ItemList.get_item_text(item_selected)

func _on_item_list_item_activated(index: int) -> void: #redundacia, este es para clicks doble
	pass

func _on_item_list_item_selected(index: int) -> void:
	item_selected = $ItemList.get_selected_items()[0]

func send_notification(notif: String):
	$RichTextLabel.text = notif
