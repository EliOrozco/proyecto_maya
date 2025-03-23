extends Control

func _on_cancelar_button_mods_pressed() -> void:
	get_node(".").queue_free()
