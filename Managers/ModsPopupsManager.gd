extends Control
signal infoItem

func _ready() -> void:
	#onnect("infoItem", self, "infoItemFunc")
	pass

func _on_cancelar_button_mods_pressed() -> void:
	get_node(".").queue_free() #se elimina a si mismo para cancelar

func _on_aplicar_button_mods_pressed() -> void:
	pass

func infoItemFunc():
	pass
