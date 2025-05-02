extends Window

signal clear_ticket_signal

var calculatedFinalPriceLabel : RichTextLabel
var moneyReceived : LineEdit
var moneyChangeLabel : Label
var window : Window
var money : float
var moneyChange : float

var calculatedFinalPrice : float
var currentTicket : Array
var ticketNumber : int

func init(calculatedFinalPriceLabelQuery : float, currentTicketQuery : Array, ticketNumberQuery : int) -> void:
	window = $"."
	calculatedFinalPriceLabel = $Control/MarginContainer/VBoxContainer/calculatedFinalPriceLabel
	moneyReceived = $Control/MarginContainer/VBoxContainer/MoneyReceivedInput
	moneyChangeLabel = $Control/MarginContainer/VBoxContainer/MoneyToGiveLabel
	calculatedFinalPrice = calculatedFinalPriceLabelQuery
	calculatedFinalPriceLabel.text = "$" + str(calculatedFinalPrice)
	currentTicket = currentTicketQuery
	moneyReceived.text = str(calculatedFinalPrice)
	ticketNumber = ticketNumberQuery
	update_change_money()

func _ready() -> void:
	await get_tree().process_frame
	window.grab_focus()
	moneyReceived.grab_focus()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escap"):
		_on_cancelar_button_pressed()
	if Input.is_action_just_pressed("f2"):
		_on_imprimir_button_pressed()

func _on_bill_20_pressed() -> void:
	moneyReceived.text = "20"
	update_change_money()

func _on_bill_50_pressed() -> void:
	moneyReceived.text = "50"
	update_change_money()

func _on_bill_100_pressed() -> void:
	moneyReceived.text = "100"
	update_change_money()

func _on_bill_200_pressed() -> void:
	moneyReceived.text = "200"
	update_change_money()

func _on_bill_500_pressed() -> void:
	moneyReceived.text = "500"
	update_change_money()

func _on_cancelar_button_pressed() -> void:
	window.queue_free()

func _on_money_received_input_text_changed(_new_text: String) -> void:
	update_change_money()

func update_change_money():
	money = float(moneyReceived.text)
	moneyChange = money - calculatedFinalPrice
	moneyChangeLabel.text = "$" + str(moneyChange)

func _on_imprimir_button_pressed() -> void:
	DbManager.clear_section_queries()
	PrinterManager.ticket_number = ticketNumber
	PrinterManager.ticket_list = currentTicket #cambiar por currentTicketJson
	PrinterManager.ticket_total = calculatedFinalPrice
	PrinterManager.money_received = moneyReceived.text
	PrinterManager.money_change = moneyChange
	PrinterManager.ConectToPrinter()
	NotifMessage.send("Imprimendo Ticket...")
	clear_ticket_signal.emit()
	window.queue_free()
