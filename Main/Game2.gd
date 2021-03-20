extends Node2D


enum GameState {
	# Before starting the game, can use the currency to buy bonuses
	Buying,
	# Play!
	Playing,
	# Display some metrics about the game and show the retry, quit screen
	Dying,
}
var game_state = GameState.Buying

var money_earned = 0

var next_x_threshold = 2048
const STOPPED_VEL = 0.05
const TRANCH_SIZE = 2048

var max_altitude = 0

onready var player_initial_pos = $Player.position
onready var ground_zero_pos = Vector2($Player.position.x, $GroundZero.position.y)
onready var tranches_pos = [
	$Tranches/Tranch0.position,
	$Tranches/Tranch1.position,
	$Tranches/Tranch2.position,
	$Tranches/Tranch3.position
]

# Stuff that the player can buy from the shop
var current_inventory = get_default_inventory()
func _ready():
	Save.load_game()
	$Player.update_launcher_sprite()
	$CanvasLayer/BuyMenu.update_money()
	$CanvasLayer/BuyMenu.update_buy_buttons(current_inventory)

func _on_MarginContainer2_start_game():
	$CanvasLayer/BuyMenu.hide()
	$CanvasLayer/HUD.show()
	$Player.update_inventory(current_inventory)
	$Player.set_ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasLayer/HUD.set_genkiness($Player.genkiness)

	if $Player.position.x > next_x_threshold:
		var tranch_on_left = get_most_left_tranch()
		tranch_on_left.position.x = next_x_threshold + 2 * TRANCH_SIZE
		next_x_threshold += TRANCH_SIZE

		tranch_on_left.generate_props()
		
	var distances = compute_distances()
	max_altitude = max(max_altitude, distances.y)
	$CanvasLayer/HUD.update_positions(distances.x, distances.y)

func compute_distances() -> Vector2:
	var distances = $Player.position - ground_zero_pos
	return Vector2(floor(distances.x/100), floor(-distances.y/100))

func get_most_left_tranch():
	""" the one to the left of the next X threshold """
	for tranch in $Tranches.get_children():
		if tranch.position.x < next_x_threshold-TRANCH_SIZE:
			return tranch


func _on_Player_game_over():
	
	var distances = compute_distances()
	$CanvasLayer/GameOverPanel.set_stats(distances.x, max_altitude, money_earned)
	Save.compute_stats(distances.x, max_altitude)
	
	# Add money to the walled
	Wallet.add_to_wallet(money_earned)
	money_earned = 0
	
	Save.save_game()
	
	$CanvasLayer/BuyMenu.update_money()
	$CanvasLayer/HUD.hide()
	$CanvasLayer/GameOverPanel.show()

func _on_Player_add_money(amt):
	money_earned += amt
	$CanvasLayer/HUD.update_money(money_earned)


func _on_GameOverPanel_restart():
	# Replace player.
	$Player.reset(player_initial_pos)
	
	# background
	next_x_threshold = 2048
	$Tranches/Tranch0.reset(tranches_pos[0])
	$Tranches/Tranch1.reset(tranches_pos[1])
	$Tranches/Tranch2.reset(tranches_pos[2])
	$Tranches/Tranch3.reset(tranches_pos[3])
	
	# Hide game over screen and show the shop
	current_inventory = get_default_inventory()
	$CanvasLayer/BuyMenu.update_buy_buttons(current_inventory)
	$CanvasLayer/BuyMenu.show()
	$CanvasLayer/GameOverPanel.hide()

func get_default_inventory():
	return  {
		"rocket": false,
		"helmet": false,
		"wings": false,
	}

# SHOP !!!
# ----------------------------------------------------------------------------
const PRICES = {
	"helmet": 200,
	"rocket": 50,
	"first_upgrade": 500,
	"second_upgrade": 2000,
	"wings": 100
}


func _on_BuyMenu_buy_helmet():
	if Wallet.can_buy(PRICES["helmet"]) && current_inventory["helmet"] == false:
		Wallet.remove_from_wallet(PRICES["helmet"])
		current_inventory["helmet"] = true
		$CanvasLayer/BuyMenu.update_money()
		$CanvasLayer/BuyMenu.update_buy_buttons(current_inventory)


func _on_BuyMenu_buy_rocket():
	if Wallet.can_buy(PRICES["rocket"]) && current_inventory["rocket"] == false:
		Wallet.remove_from_wallet(PRICES["rocket"])
		current_inventory["rocket"] = true
		$CanvasLayer/BuyMenu.update_money()
		$CanvasLayer/BuyMenu.update_buy_buttons(current_inventory)


func _on_BuyMenu_buy_upgrade():
	if Save.upgrade_level >= 2:
		return
		
	var price
	if Save.upgrade_level == 0:
		price = PRICES["first_upgrade"]
	else:
		price = PRICES["second_upgrade"]
		
	if Wallet.can_buy(price):
		Wallet.remove_from_wallet(price)
		Save.upgrade_level += 1
		$CanvasLayer/BuyMenu.update_money()
		$CanvasLayer/BuyMenu.update_buy_buttons(current_inventory)


func _on_BuyMenu_buy_wings():
	if Wallet.can_buy(PRICES["wings"]) && current_inventory["wings"] == false:
		Wallet.remove_from_wallet(PRICES["wings"])
		current_inventory["wings"] = true
		$CanvasLayer/BuyMenu.update_money()
		$CanvasLayer/BuyMenu.update_buy_buttons(current_inventory)


func _on_Player_used_helmet():
	current_inventory["helmet"] = false


func _on_Player_used_rocket():
	current_inventory["rocket"] = false
