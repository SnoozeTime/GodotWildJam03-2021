extends Camera2D

export(float, 0, 500) var lookahead = 400.0

var updown_offset = 0.0
onready var player = $"../Player"
onready var max_altitude: float = $"../MaxAltitude".position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = player.position+Vector2.RIGHT*lookahead + Vector2.DOWN*updown_offset
	
	position.y = max(max_altitude+get_viewport_rect().size.y, position.y)
