extends Sprite

signal entered_tile()


var bird = preload("res://Main/AssholeBird.tscn")
var jumppad = preload("res://Main/Jump.tscn")
var propulsion = preload("res://Main/Propulsion.tscn")


# Textures
var sky_to_ground_tex = preload("res://Assets/Textures/sky_to_ground.png")
var ground_tex = preload("res://Assets/Textures/ground.png")
var sky_tex = preload("res://Assets/Textures/Sky.png")
var inside_ground_tex = preload("res://Assets/Textures/inside_ground.png")

export var max_birds = 4
export var birds_per_tranch: int = 1

export var tile_x_index = 0
export var tile_y_index = 0
export var label = "sky"

const INITIAL_X_OFFSET = Globals.INITIAL_X_OFFSET
const INITIAL_Y_OFFSET = Globals.INITIAL_Y_OFFSET
const TILE_SIZE = Globals.TILE_SIZE
# Difficulty increases every 10.
const TILE_TRANCH_SIZE = 10

func _ready():
	$Label.text = "(%s,%s)" % [tile_x_index, tile_y_index]
	spawn_props()

func _on_Sky1Area_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("entered_tile", self, body)

func set_new_index(x_offset, y_offset):

	tile_x_index = x_offset
	tile_y_index = y_offset
	position.x = INITIAL_X_OFFSET + TILE_SIZE * x_offset
	position.y = INITIAL_Y_OFFSET + TILE_SIZE * y_offset
	$Label.text = "(%s,%s)" % [tile_x_index, tile_y_index]
	
	
	# choose the texture according to height.
	choose_tex()
	
	# Spawn stuff. Needs to be done at some other point because this is modifying
	# physics stuff.
	call_deferred("spawn_props")

func choose_tex():
	
	match tile_y_index:
		Globals.GROUND_IDX:
			texture = ground_tex
		Globals.GROUND_TO_SKY_IDX:
			texture = sky_to_ground_tex
		Globals.INSIDE_GROUND_IDX:
			texture = inside_ground_tex
		_:
			texture = sky_tex


func spawn_props():
	if tile_y_index == Globals.GROUND_IDX:
		$StaticBody2D/CollisionShape2D.disabled = false
	else:
		$StaticBody2D/CollisionShape2D.disabled = true
	
	# Replace birds and obstacles and so on.
	remove_all_props()

	var to_spawn = get_nb_to_spawn()	
	var birds_to_spawn = to_spawn["birds"]
	for _i in (birds_to_spawn):
		var b = bird.instance()
		$Birds.add_child(b)
		b.position = Vector2(TILE_SIZE/2.0 + rand_range(-200.0, 200.0), rand_range(-TILE_SIZE/2.0, TILE_SIZE/2.0))
	
	var jumppads_to_spawn = to_spawn["jumppads"]
	for _i in (jumppads_to_spawn):
		var j = jumppad.instance()
		$JumpPads.add_child(j)
		j.position = Vector2(rand_range(-TILE_SIZE/2.0, TILE_SIZE/2.0), rand_range(-TILE_SIZE/2.0, TILE_SIZE/2.0))
	
	var prop_to_spawn = to_spawn["propulsions"]
	for _i in (prop_to_spawn):
		var p = propulsion.instance()
		$Propulsions.add_child(p)
		p.position = Vector2(rand_range(-TILE_SIZE/2.0, TILE_SIZE/2.0), rand_range(-TILE_SIZE/2.0, TILE_SIZE/2.0))

func remove_all_props():
	for b in $Birds.get_children():
		b.queue_free()

	for jumppads in $JumpPads.get_children():
		jumppads.queue_free()
	
	for propulsion_child in $Propulsions.get_children():
		propulsion_child.queue_free()


func get_nb_to_spawn():
	""" Depending on the difficulty (x index), there will be more stuff that spawns to stop the player.
	"""
	
	var tile_tranch = int(round(tile_x_index / TILE_TRANCH_SIZE))
	var jumppads = 2 + randi() % 4
	var propulsions = randi() % 2
	
	return {
		"birds": randi() % (tile_tranch * birds_per_tranch + 1),
		"jumppads": jumppads,
		"propulsions": propulsions
	}
