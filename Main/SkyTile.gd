extends Sprite

signal entered_tile()


var bird = preload("res://Main/AssholeBird.tscn")
var jumppad = preload("res://Main/Jump.tscn")
var propulsion = preload("res://Main/Propulsion.tscn")


# Textures
var sky_to_ground_tex = preload("res://Assets/Textures/sky_to_ground.png")
var ground_tex = preload("res://Assets/Textures/ground.png")
var ground_sky_tex = preload("res://Assets/Textures/ground_sky.png")
var sky_tex = preload("res://Assets/Textures/Sky.png")
var inside_ground_tex = preload("res://Assets/Textures/inside_ground.png")
var sky_to_atmos_tex = preload("res://Assets/Textures/sky_to_highatmos.png")
var atmos_tex = preload("res://Assets/Textures/highatmos.png")
var atmos_to_space_tex = preload("res://Assets/Textures/highatmos_to_space.png")
var space_tex = preload("res://Assets/Textures/space.png")

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



enum Section {
	InsideGround,
	Ground,
	LowSky,
	LowSkyToSky,
	Sky,
	SkyToAtmos,
	Atmos,
	AtmosToSpace,
	Space,
}

var section_to_tex = {
	Section.InsideGround: inside_ground_tex,
	Section.Ground: ground_tex,
	Section.LowSky: ground_sky_tex,
	Section.LowSkyToSky: sky_to_ground_tex,
	Section.Sky: sky_tex,
	Section.SkyToAtmos: sky_to_atmos_tex,
	Section.Atmos: atmos_tex,
	Section.AtmosToSpace: atmos_to_space_tex,
	Section.Space: space_tex,
}

var section_to_max_jumpad = {
	Section.InsideGround: 4,
	Section.Ground: 4,
	Section.LowSky: 4,
	Section.LowSkyToSky: 4,
	Section.Sky: 4,
	Section.SkyToAtmos: 3,
	Section.Atmos: 3,
	Section.AtmosToSpace: 2,
	Section.Space: 0,
}

var section = Section.Sky

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
	update_section()
	choose_tex()
	
	# Spawn stuff. Needs to be done at some other point because this is modifying
	# physics stuff.
	call_deferred("spawn_props")

func choose_tex():
	texture = section_to_tex[section]

func update_section():
	if tile_y_index == Globals.INSIDE_GROUND_IDX:
		section = Section.InsideGround
	elif tile_y_index == Globals.GROUND_IDX:
		section = Section.Ground
	elif tile_y_index > Globals.GROUND_TO_SKY_IDX:
		section = Section.LowSky
	elif tile_y_index == Globals.GROUND_TO_SKY_IDX:
		section = Section.LowSkyToSky
	elif tile_y_index > Globals.SKY_TO_ATMOS_IDX:
		section = Section.Sky
	elif tile_y_index == Globals.SKY_TO_ATMOS_IDX:
		section = Section.SkyToAtmos
	elif tile_y_index > Globals.ATMOS_TO_SPACE_IDX:
		section = Section.Atmos
	elif tile_y_index == Globals.ATMOS_TO_SPACE_IDX:
		section = Section.AtmosToSpace
	else:
		section = Section.Space


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
	
	var jumppads = 0
	if section_to_max_jumpad[section] > 0:
		jumppads = randi() % section_to_max_jumpad[section]
	var propulsions = randi() % 2
	
	return {
		"birds": randi() % (tile_tranch * birds_per_tranch + 1),
		"jumppads": jumppads,
		"propulsions": propulsions
	}
