extends Sprite


func _process(_delta):
	translate(Vector2.LEFT*5.0)

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):

		body.bird_collision()
		$AudioStreamPlayer.play()
		
		$Area2D/CollisionShape2D.disabled = true
		hide()
		


func _on_AudioStreamPlayer_finished():
	queue_free()
