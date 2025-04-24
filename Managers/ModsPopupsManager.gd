extends Node

@onready var window = $"."

func _ready() -> void:
	pass

func _on_cancelar_button_pressed() -> void:
	DbManager.clear_mods_queries()
	window.queue_free()
