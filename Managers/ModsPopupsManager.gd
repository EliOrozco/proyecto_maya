extends Node

signal sendOptionsSelected(optionsSelected, optionsSelectedNames, optionsSelectedPrices, cantidadSelected)

@onready var window = $"."
@onready var optionsContainer = $PopUP/ColorDeFondo/ContenedotV/Margenes/ContenedorOpciones
@onready var cantidadSelector = $PopUP/ColorDeFondo/ContenedotV/DivisorCantidad/Cantidad

#var modsIdQueried : Array = []

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

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escap"):
		_on_cancelar_button_pressed()
	if Input.is_action_just_pressed("plussign"):
		cantidadSelector.value = cantidadSelector.value + 1
	if Input.is_action_just_pressed("minussign"):
		cantidadSelector.value = cantidadSelector.value - 1
	if Input.is_action_just_pressed("f2"):
		_on_seleccionar_todo_pressed()
	if Input.is_action_just_pressed("f3"):
		_on_seleccionar_nada_pressed()
	if Input.is_action_just_pressed("f4"):
		_on_aceptar_button_pressed()
	if Input.is_action_just_pressed("ctrl"):
		optionsContainer.get_child(0).grab_focus()
		

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
	var i : int = 0
	for child in children:
		if child.button_pressed == true:
			optionsSelected.append(DbManager.modsList[i])
		i = i + 1
	for j in optionsSelected.size():
		DbManager.get_mod_info(optionsSelected[j])
		optionsSelectedNames.append(DbManager.nombreMod)
		optionsSelectedPrices.append(DbManager.ajustePrecioMod)
	
	#send to main scene
	var cantidadSelected : int = cantidadSelector.value
	sendOptionsSelected.emit(optionsSelected, optionsSelectedNames, optionsSelectedPrices, cantidadSelected)
	DbManager.clear_mods_queries()
	DbManager.clear_mod_info()
	window.queue_free()
