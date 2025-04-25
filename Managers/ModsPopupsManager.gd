extends Node

signal sendOptionsSelected(optionsSelected, cantidadSelected)

@onready var window = $"."
@onready var optionsContainer = $PopUP/ColorDeFondo/ContenedotV/Margenes/ContenedorOpciones
@onready var cantidadSelector = $PopUP/ColorDeFondo/ContenedotV/DivisorCantidad/Cantidad

var optionsSelected : Array = []

func _ready() -> void:
	for i in DbManager.modsList.size():
		DbManager.get_mod_info(DbManager.modsList[i]) #es para evitar una referencia a modificador_id = 0
		
		var checkBox = CheckBox.new()
		optionsContainer.add_child(checkBox)
		
		var checkBoxReference = optionsContainer.get_child(i)
		checkBoxReference.text = DbManager.nombreMod

func _on_cancelar_button_pressed() -> void:
	DbManager.clear_mods_queries()
	DbManager.clear_mod_info()
	window.queue_free()

func _on_seleccionar_todo_pressed() -> void:
	var children = optionsContainer.get_children()
	for child in children:
		child.button_pressed = true;

func _on_seleccionar_nada_pressed() -> void:
	var children = optionsContainer.get_children()
	for child in children:
		child.button_pressed = false;

func _on_aceptar_button_pressed() -> void:
	var children = optionsContainer.get_children()
	for child in children:
		if child.button_pressed == true:
			optionsSelected.append(1)
		else:
			optionsSelected.append(0)
	
	#send to main scene
	var cantidadSelected : int = cantidadSelector.value
	sendOptionsSelected.emit(optionsSelected, cantidadSelected)
	DbManager.clear_mods_queries()
	DbManager.clear_mod_info()
	window.queue_free()
