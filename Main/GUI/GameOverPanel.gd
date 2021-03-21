extends MarginContainer

signal restart()
signal quit()


func _on_StartButton_pressed():
	emit_signal("restart")


func _on_QuitButton_pressed():
	emit_signal("quit")

func set_stats(distance, altitude, money):
	$Control/MarginContainer/VBoxContainer/VBoxContainer/DistanceLabel/Label.text = "%sm" % distance
	$Control/MarginContainer/VBoxContainer/VBoxContainer/AltitudeLabel/Label.text = "%sm" % altitude
	$Control/MarginContainer/VBoxContainer/VBoxContainer/MoneyLabel.text = "$%s" % money
	
	if distance > Save.longest_distance:
		$Control/MarginContainer/VBoxContainer/VBoxContainer/DistanceNewRecord.text = "New record!!"
	else:
		$Control/MarginContainer/VBoxContainer/VBoxContainer/DistanceNewRecord.text = ""

	if altitude > Save.highest_altitude:
		$Control/MarginContainer/VBoxContainer/VBoxContainer/AltitudeNewRecord.text = "New record!!"
	else:
		$Control/MarginContainer/VBoxContainer/VBoxContainer/AltitudeNewRecord.text = ""
