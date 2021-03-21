extends Sprite


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.refill_flaps()
		$AudioStreamPlayer.play()
		$Area2D/CollisionShape2D.disabled = true
		hide()

func _on_AudioStreamPlayer_finished():
	call_deferred("queue_free")
