extends Node2D

var tile_scene = preload("res://Main/SkyTile.tscn")

func _ready():
	for tile in $SkyTiles.get_children():
		tile.connect("entered_tile", self, "spawn_new_tiles")


var player_x_index: int = 0 # next tile will be at offset + 2 * 512
var player_y_index: int = 0


func _process(_delta):
	$CanvasLayer/GUI.set_velocity($Player.velocity)
	
	update_distances()
	
	if Input.is_action_just_pressed("Reset"):
		reset_game()

func spawn_new_tiles(tile, _body):

	var tile_x_index = tile.tile_x_index
	var tile_y_index = tile.tile_y_index
	# Do not process tiles on the left. The game always goes to the right, up/down
	if tile_x_index < player_x_index:
		return
	#print("Player (%s, %s)" % [player_x_index, player_y_index])

	if tile_x_index == player_x_index && tile_y_index < player_y_index:
		# NORTH
		player_x_index = tile_x_index
		player_y_index = tile_y_index

		# S, SE and SW to be repositioned.
		reposition_tile(tile_x_index-1, tile_y_index+2, tile_x_index-1, tile_y_index-1)
		reposition_tile(tile_x_index, tile_y_index+2, tile_x_index, tile_y_index-1)
		reposition_tile(tile_x_index+1, tile_y_index+2, tile_x_index+1, tile_y_index-1)
	elif tile_x_index > player_x_index && tile_y_index < player_y_index:
		# NORTH EAST
		player_x_index = tile_x_index
		player_y_index = tile_y_index
		
		reposition_tile(tile_x_index-2, tile_y_index, tile_x_index+1, tile_y_index-1)
		reposition_tile(tile_x_index-2, tile_y_index+1, tile_x_index+1, tile_y_index)
		reposition_tile(tile_x_index-2, tile_y_index+2, tile_x_index+1, tile_y_index+1)
		reposition_tile(tile_x_index-1, tile_y_index+2, tile_x_index-1, tile_y_index-1)
		reposition_tile(tile_x_index, tile_y_index+2, tile_x_index, tile_y_index-1)
		
	elif tile_x_index > player_x_index && tile_y_index == player_y_index:
		# EAST TILE !
		player_x_index = tile_x_index
		# New East tile
		reposition_tile(tile_x_index-2, tile_y_index, player_x_index+1, player_y_index)
		# New NE tile
		reposition_tile(tile_x_index-2, player_y_index-1, player_x_index+1, player_y_index-1)
		# New SE tile
		reposition_tile(tile_x_index-2, player_y_index+1, player_x_index+1, player_y_index+1)
	elif tile_x_index > player_x_index && tile_y_index > player_y_index:
		# SOUTH-EAST TILE!
		player_x_index = tile_x_index
		player_y_index = tile_y_index
		
		reposition_tile(tile_x_index-2, tile_y_index, tile_x_index+1, tile_y_index-1)
		reposition_tile(tile_x_index-2, tile_y_index-1, tile_x_index+1, tile_y_index)
		reposition_tile(tile_x_index-2, tile_y_index-2, tile_x_index+1, tile_y_index+1)
		reposition_tile(tile_x_index-1, tile_y_index-2, tile_x_index-1, tile_y_index+1)
		reposition_tile(tile_x_index, tile_y_index-2, tile_x_index, tile_y_index+1)
		
	elif tile_x_index == player_x_index && tile_y_index > player_y_index:
		# SOUTH
		player_x_index = tile_x_index
		player_y_index = tile_y_index

		# S, SE and SW to be repositioned.
		reposition_tile(tile_x_index-1, tile_y_index-2, tile_x_index-1, tile_y_index+1)
		reposition_tile(tile_x_index, tile_y_index-2, tile_x_index, tile_y_index+1)
		reposition_tile(tile_x_index+1, tile_y_index-2, tile_x_index+1, tile_y_index+1)

func reposition_tile(tile_x, tile_y, new_x, new_y):
	var tile = find_tile(tile_x, tile_y)
	tile.set_new_index(new_x, new_y)

func find_tile(x_offset, y_offset):
	for tile in $SkyTiles.get_children():
		if tile.tile_x_index == x_offset && tile.tile_y_index == y_offset:
			return tile


func _on_Player_dive_status(status):
	if status:
		$CanvasLayer/GUI.set_dive_ready()
	else:
		$CanvasLayer/GUI.set_dive_not_ready()

func _on_Player_hover_status(status):
	$CanvasLayer/GUI.set_hover_ready(status)
	
	
func update_distances():
	""" How far the player goes """
	var ground_y = Globals.TILE_SIZE*(Globals.GROUND_IDX+1) - 186 # MAGIC NUMBER !
	var height = (ground_y - $Player.position.y) / 100.0
	var distance = ($Player.position.x - 100.0) / 100.0
	
	$CanvasLayer/GUI.set_distances(height, distance)
	
func reset_game():
	
	# First the tiles.
	for sky in $SkyTiles.get_children():
		$SkyTiles.remove_child(sky)	
		sky.queue_free()
	
	for x in range(0, 3):
		for y in range(0, 3):
			var tile = tile_scene.instance()
			$SkyTiles.add_child(tile)
			tile.set_new_index(x-1, y-1)
			tile.connect("entered_tile", self, "spawn_new_tiles")
			
	# Reset player
	$Player.reset()
