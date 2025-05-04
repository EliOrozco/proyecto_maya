extends Node

@onready var notifMesg = $"."
@onready var notifText = $NotifPanel/TextoNotif
@onready var timer = $NotifPanel/Timer

var backlog : Array = []

func send(textReceived : String):
	backlog.append(textReceived)
	_show() #verificar que no haya errores con llamadas múltiples

func _show():
	if backlog.is_empty():
		hide()
	else:
		var get_time = Time.get_time_string_from_system()
		notifText.text = "(" + str(backlog.size()) + ")(" + get_time + ") / " + backlog.front()
		notifMesg.visible = true
		timer.start()

func hide():
	notifMesg.visible = false

func _on_timer_timeout() -> void:
	backlog.pop_front()
	_show()
