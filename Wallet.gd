extends Node

var money_in_wallet: int = 0


func can_buy(amt: int) -> bool:
	return money_in_wallet - amt >= 0
	
func add_to_wallet(amt: int) -> void:
	if amt > 0:
		money_in_wallet += amt
		
func remove_from_wallet(amt: int) -> void:
	if amt > 0:
		money_in_wallet = max(0, money_in_wallet - amt)
