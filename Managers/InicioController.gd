extends Control

@onready var CargaInicio : ProgressBar = $ColorInicio/LogoContainer/LogoBarraCarga/CargaInicio #referencia a la interfaz a barra de cargA
var cargatotal : int = 0 #VALOR ASIGNADO BARRA DE CARGA 
@export var paso : int = 25 #cant minima avance de carga

func _ready() -> void: 
	#get_viewport().size = Vector2i(1280,720)
	#get_viewport().size = DisplayServer.screen_get_size()
	pass
	
func _process(_delta: float) -> void: #carga total
	CargaInicio.value = cargatotal #asigna el valor de la carga a la propiedad 
	if (cargatotal >= 100):
		get_tree().change_scene_to_file("res://Scenes/Interface.tscn") #cambia a la pantalla principal

func _on_cargador_timeout() -> void: 
	cargatotal += paso
