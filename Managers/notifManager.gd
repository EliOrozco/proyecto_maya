extends Node

@onready var notifMesg = $"."
@onready var notifText = $NotifPanel/TextoNotif
@onready var timer = $NotifPanel/Timer

func send(textReceived : String):
	notifText.text = textReceived
	notifMesg.visible = true
	timer.start()
	
func hide():
	notifMesg.visible = false

func _on_timer_timeout() -> void:
	notifMesg.visible = false
