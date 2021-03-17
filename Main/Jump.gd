extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	scale *= rand_range(0.9, 2.0)

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.on_jump()
