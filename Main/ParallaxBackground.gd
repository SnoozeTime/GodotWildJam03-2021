extends ParallaxBackground


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var scroll = Vector2(3,0) #Some default scrolling so there's always movement.
	if get_parent().get_node("Player") != null:
		scroll.x += get_parent().get_node("Player").velocity.x / 200
	scroll_offset.x += scroll.x
