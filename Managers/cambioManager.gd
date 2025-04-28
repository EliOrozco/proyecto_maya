extends Window

var calculatedFinalPriceLabel : RichTextLabel
var moneyReceived : LineEdit
var moneyChange : Label
var money : float

var calculatedFinalPrice

func init(calculatedFinalPriceLabelQuery) -> void:
	calculatedFinalPriceLabel = $Control/MarginContainer/VBoxContainer/calculatedFinalPriceLabel
	moneyReceived = $Control/MarginContainer/VBoxContainer/MoneyReceivedInput
	moneyChange = $Control/MarginContainer/VBoxContainer/MoneyToGiveLabel
	calculatedFinalPrice = calculatedFinalPriceLabelQuery
	calculatedFinalPriceLabel.text = "$" + str(calculatedFinalPrice)

func _process(_delta: float) -> void:
	money = float(moneyReceived.text)
	moneyChange.text = "$" + str(money - calculatedFinalPrice)

func _on_bill_20_pressed() -> void:
	moneyReceived.text = "20"

func _on_bill_50_pressed() -> void:
	moneyReceived.text = "50"

func _on_bill_100_pressed() -> void:
	moneyReceived.text = "100"


func _on_bill_200_pressed() -> void:
	moneyReceived.text = "200"


func _on_bill_500_pressed() -> void:
	moneyReceived.text = "500"

func _on_cancelar_button_pressed() -> void:
	queue_free()
