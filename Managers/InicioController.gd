extends Control

@onready var CargaInicio : ProgressBar = $ColorInicio/LogoContainer/CargaInicio
var cargatotal : int = 0
@export var paso : int = 25

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	CargaInicio.value = cargatotal
	if (cargatotal >= 100):
		get_tree().change_scene_to_file("res://Scenes/Interface.tscn")

func _on_cargador_timeout() -> void:
	cargatotal += paso
