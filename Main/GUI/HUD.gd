extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func update_positions(distance, altitude):
	$MarginContainer/HBoxContainer/DistanceLabel/Label.text = "%sm" % distance
	$MarginContainer/HBoxContainer/AltitudeLabel/Label.text = "%sm" % altitude

func set_genkiness(g):
	$MarginContainer/HBoxContainer/TextureProgress.set_value(g)

func update_money(amt):
	$MoneyLabel.text = "$%s" % amt
