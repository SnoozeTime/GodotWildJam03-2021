extends Control

var flap_scene = preload("res://Main/GUI/Flap.tscn")

onready var flap_container = $MarginContainer/HBoxContainer/Flaps

func update_positions(distance, altitude):
	$MarginContainer/HBoxContainer/DistanceLabel/Label.text = "%sm" % distance
	$MarginContainer/HBoxContainer/AltitudeLabel/Label.text = "%sm" % altitude

func update_money(amt):
	$MoneyLabel.text = "$%s" % amt
	
func set_flaps(nb):

	for f in flap_container.get_children():
		flap_container.remove_child(f)
		f.queue_free()
	
	for _i in range(nb):
		flap_container.add_child(flap_scene.instance())

func update_inventory(inventory):
	if inventory["helmet"]:
		$BonusesContainer/HelmetIcon.show()
	else:
		$BonusesContainer/HelmetIcon.hide()
	if inventory["wings"]:
		$BonusesContainer/WingIcon.show()
	else:
		$BonusesContainer/WingIcon.hide()
	if inventory["rocket"]:
		$BonusesContainer/RocketIcon.show()
	else:
		$BonusesContainer/RocketIcon.hide()
