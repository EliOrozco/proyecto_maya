extends Window

var calculatedFinalPriceLabel : RichTextLabel
var moneyReceived : LineEdit
var moneyChange : Label
var money : float

var calculatedFinalPrice

func init(calculatedFinalPriceLabelQuery) -> void:
	calculatedFinalPriceLabel = $MarginContainer/VBoxContainer/calculatedFinalPriceLabel
	moneyReceived = $MarginContainer/VBoxContainer/MoneyReceivedInput
	moneyChange = $MarginContainer/VBoxContainer/MoneyToGiveLabel
	calculatedFinalPrice = calculatedFinalPriceLabelQuery
	calculatedFinalPriceLabel.text = "$" + str(calculatedFinalPrice)
	pass

func _process(delta: float) -> void:
	money = float(moneyReceived.text)
	moneyChange.text = "$" + str(money - calculatedFinalPrice)
	

func _on_bill_20_pressed() -> void:
	moneyReceived.text = "20"
	pass # Replace with function body.


func _on_bill_50_pressed() -> void:
	moneyReceived.text = "50"
	pass # Replace with function body.


func _on_bill_100_pressed() -> void:
	moneyReceived.text = "100"
	pass # Replace with function body.


func _on_bill_200_pressed() -> void:
	moneyReceived.text = "200"
	pass # Replace with function body.


func _on_bill_500_pressed() -> void:
	moneyReceived.text = "500"
	pass # Replace with function body.


func _on_cancelar_button_pressed() -> void:
	queue_free()
	pass # Replace with function body.
