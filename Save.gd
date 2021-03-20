extends Node

var highest_altitude=0
var longest_distance=0

# How good is the start cannon
var upgrade_level = 0

func compute_stats(dist, alt):
	""" Update the records """
	highest_altitude = max(highest_altitude, alt)
	longest_distance = max(longest_distance, dist)

func save_game():
	var save_dict = {
		"altitude": highest_altitude,
		"distance": longest_distance,
		"upgrade_level": upgrade_level,
		"money": Wallet.money_in_wallet
	}
	
	var file = File.new()
	file.open("user://savegame.save", File.WRITE)
	
	var serialized = to_json(save_dict)
	file.store_line(serialized)
	file.close()
	
func load_game():
	var file = File.new()
	if not file.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	file.open("user://savegame.save", File.READ)

	var deserialized = parse_json(file.get_line())

	highest_altitude = deserialized['altitude']
	longest_distance = deserialized['distance']
	upgrade_level = deserialized['upgrade_level']
	Wallet.money_in_wallet = deserialized['money']
	
	file.close()
