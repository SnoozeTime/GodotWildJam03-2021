extends MarginContainer

signal start_game()
signal buy_wings()
signal buy_rocket()
signal buy_upgrade()
signal buy_helmet()

func _ready():
	update_money()
	
	if Save.upgrade_level >= 2:
		$Control/MarginContainer/VBoxContainer/ItemsToBuy/UpgradeBuy.disabled = true
		$Control/MarginContainer/VBoxContainer/ItemsToBuy/UpgradeBuy.text = "Fully upgraded!"
		

func update_buy_buttons(inventory):
	
	$Control/MarginContainer/VBoxContainer/ItemsToBuy/RocketBuy.disabled = inventory["rocket"]
	$Control/MarginContainer/VBoxContainer/ItemsToBuy/HelmetBuy.disabled = inventory["helmet"]
	$Control/MarginContainer/VBoxContainer/ItemsToBuy/WingBuy.disabled = inventory["wings"]
	
	if Save.upgrade_level >= 2:
		$Control/MarginContainer/VBoxContainer/ItemsToBuy/UpgradeBuy.disabled = true
		$Control/MarginContainer/VBoxContainer/ItemsToBuy/UpgradeBuy.text = "Fully upgraded!"


func _on_StartButton_pressed():
	emit_signal("start_game")

func update_money():
	$Control/MarginContainer/VBoxContainer/MoneyLabel.text = "$%s" % Wallet.money_in_wallet

func _on_UpgradeBuy_pressed():
	emit_signal("buy_upgrade")

func _on_WingBuy_pressed():
	emit_signal("buy_wings")

func _on_HelmetBuy_pressed():
	emit_signal("buy_helmet")

func _on_RocketBuy_pressed():
	emit_signal("buy_rocket")
