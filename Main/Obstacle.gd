extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const BASE_STR: float = 200.0

export(float, 0, 100.0) var speed: float = 0.0
export(Vector2) var impulse = Vector2.ONE 

func _process(delta):
	global_translate(Vector2.LEFT * speed)

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.on_jump(BASE_STR*impulse)
