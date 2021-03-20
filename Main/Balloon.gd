extends Sprite

export(float) var speed = 5.0


func _physics_process(delta):
	position.y -= delta * speed


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.on_jump(1500.0*Vector2.UP)
		$AnimationPlayer.play("Pop")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Pop":
		call_deferred("queue_free")
