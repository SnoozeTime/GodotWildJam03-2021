extends MarginContainer

func set_dive_ready() -> void:
	$HBoxContainer/Actions/DiveAction.modulate = Color(0.0, 1.1, 0.1, 1.0)
	
func set_dive_not_ready() -> void:
	$HBoxContainer/Actions/DiveAction.modulate = Color(0.1, 0.1, 0.1, 1.0)


func set_hover_ready(state: bool) -> void:
	if state:
		$HBoxContainer/Actions/HoverAction.modulate = Color(0.0, 1.1, 0.1, 1.0)
	else:
		$HBoxContainer/Actions/HoverAction.modulate = Color(0.1, 0.1, 0.1, 1.0)

	
func set_velocity(vel: Vector2) -> void:
	$HBoxContainer/Label.text = "Velocity: (%s, %s)" % [vel.x, vel.y]

func set_distances(height: float, distance: float) -> void:
	$HBoxContainer/VBoxContainer/DistanceLabel.text = "Distance: %s m" % distance
	$HBoxContainer/VBoxContainer/HeightLabel.text = "Height: %s m" % height
