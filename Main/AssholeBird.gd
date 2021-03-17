extends Sprite


func _process(delta):
	translate(Vector2.LEFT*5.0)

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.bird_collision()
		queue_free()
