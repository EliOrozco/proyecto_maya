extends Node

signal sendOptionsSelected(optionsSelected, optionsSelectedNames, optionsSelectedPrices, cantidadSelected)

@onready var window = $"."
@onready var optionsContainer = $PopUP/ColorDeFondo/ContenedotV/Margenes/ContenedorOpciones
@onready var cantidadSelector = $PopUP/ColorDeFondo/ContenedotV/DivisorCantidad/Cantidad

var optionsSelected : Array = []
var optionsSelectedNames : Array = []
var optionsSelectedPrices : Array = []

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
		var i = 0;
		if child.button_pressed == true:
			i = i + 1
			optionsSelected.append(DbManager.modsList[i])
			optionsSelectedNames.append(DbManager.nombreMod)
			optionsSelectedPrices.append(DbManager.ajustePrecioMod)
	
	#send to main scene
	var cantidadSelected : int = cantidadSelector.value
	sendOptionsSelected.emit(optionsSelected, optionsSelectedNames, optionsSelectedPrices, cantidadSelected)
	DbManager.clear_mods_queries()
	DbManager.clear_mod_info()
	window.queue_free()
