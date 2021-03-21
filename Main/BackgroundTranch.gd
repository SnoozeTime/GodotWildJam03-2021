extends Node2D


const PLACE_CAGE_PROB = 20;
const MAX_NUMBER_OF_MOVING_JUMPS = 3
const MOVING_JUMPS_PROB = 15
const ROCKET_PROB = 10;
var number_of_birds = 1
const BIRD_PROB = 20
const MONEY_PROB = 20
const FLAP_PROB = 10
const BALLOON_PROB = 10
const PLANE_PROB = 5
const CLOUD_PROB = 5
const TREE_PROB = 10
const TNT_PROB = 10

var cage_scene = preload("res://Main/Cage.tscn")
var moving_jump_scene = preload("res://Main/Cow.tscn")
var rocket_scene = preload("res://Main/Propulsion.tscn")
var bird_scene = preload("res://Main/AssholeBird.tscn")
var money_scene = preload("res://Main/MoneyBag.tscn")
var flap_scene = preload("res://Main/NewFlap.tscn")
var balloon_scene = preload("res://Main/Balloon.tscn")
var plane_scene = preload("res://Main/Plane.tscn")
var nice_cloud = preload("res://Main/NiceCloud.tscn")
var tree_scene = preload("res://Main/Tree.tscn")
var tnt_scene = preload("res://Main/TNT.tscn")

func generate_props():
	""" Add new props (jumps and so on) in the tranch. 
	"""
	delete_children($Props/GroundLevel)
	delete_children($Props/SkyLevel)
	delete_children($Props/SkyLevel2)
	delete_children($Props/SkyLevel3)
	delete_children($Props/SkyLevel4)
	delete_children($Props/AtmosLevel)
	delete_children($Props/AtmosLevel2)
	delete_children($Props/Space)
	
	# GROUND LEVEL. Cage, moving jumps and so on.
	if roll(PLACE_CAGE_PROB):
		var cage = cage_scene.instance()
		$Props/GroundLevel.add_child(cage)
		cage.position.x = rand_range(-1000, 1000)
		cage.position.y = -100
	elif roll(TREE_PROB):
		var tree = tree_scene.instance()
		$Props/GroundLevel.add_child(tree)
		tree.position.x = rand_range(-1000, 1000)

		
	for _i in (MAX_NUMBER_OF_MOVING_JUMPS):
		if roll(MOVING_JUMPS_PROB):
			var jump = moving_jump_scene.instance()
			$Props/GroundLevel.add_child(jump)
			jump.position.x = rand_range(-1000, 1000)
		elif roll(TNT_PROB):
			var tnt = tnt_scene.instance()
			$Props/GroundLevel.add_child(tnt)
			tnt.position.x = rand_range(-1000, 1000)
	if roll(MONEY_PROB):
		var money = money_scene.instance()
		$Props/GroundLevel.add_child(money)
		money.position.x = rand_range(-1000, 1000)
		money.position.y = rand_range(-1000, 0)
	if roll(FLAP_PROB):
		var flap = flap_scene.instance()
		$Props/GroundLevel.add_child(flap)
		flap.position.x = rand_range(-1000, 1000)
		flap.position.y = rand_range(-1000, 0)		
			
	# SKY LEVEL. Birds!!! Rockets !!!
	for n in [$Props/SkyLevel, $Props/SkyLevel2, $Props/SkyLevel3, $Props/SkyLevel4]:
		if roll(ROCKET_PROB):
			var rocket = rocket_scene.instance()
			n.add_child(rocket)
			rocket.position = Vector2(rand_range(-1024, 1024),rand_range(-1024, 1024))
		for _i in (number_of_birds):
			if roll(BIRD_PROB):
				var bird = bird_scene.instance()
				n.add_child(bird)
				bird.position.x = 1024
				bird.position.y = rand_range(-1024, 1024)
		if roll(MONEY_PROB):
			var money = money_scene.instance()
			n.add_child(money)
			money.position.x = rand_range(-1000, 1000)
			money.position.y = rand_range(-1000,  1024)
		if roll(FLAP_PROB):
			var flap = flap_scene.instance()
			$Props/GroundLevel.add_child(flap)
			flap.position.x = rand_range(-1000, 1000)
			flap.position.y = rand_range(-1000, 1024)	
		if roll(BALLOON_PROB):
			var balloon = balloon_scene.instance()
			n.add_child(balloon)
			balloon.position = Vector2(rand_range(-1024, 1024),rand_range(0, 1024))


	# Planes from Sky level 3 to atmos level 1
	for n in [$Props/SkyLevel3, $Props/SkyLevel4, $Props/AtmosLevel, $Props/AtmosLevel2]:
		if roll(PLANE_PROB):
			var plane = plane_scene.instance()
			n.add_child(plane)
			plane.position.x = 1024
			plane.position.y = rand_range(-1024, 1024)
		elif roll(CLOUD_PROB):
			var cloud = nice_cloud.instance()
			n.add_child(cloud)
			cloud.position.x = 1024
			cloud.position.y = rand_range(-1024, 1024)
		if roll(MONEY_PROB):
			var money = money_scene.instance()
			n.add_child(money)
			money.position.x = rand_range(-1000, 1000)
			money.position.y = rand_range(-1000,  1024)
		if roll(FLAP_PROB):
			var flap = flap_scene.instance()
			$Props/GroundLevel.add_child(flap)
			flap.position.x = rand_range(-1000, 1000)
			flap.position.y = rand_range(-1000, 1024)	

func roll(percent) -> bool:
	return (randi() % 100) <= percent
	
func reset(p):
	position = p
	delete_children($Props/GroundLevel)
	delete_children($Props/SkyLevel)
	delete_children($Props/SkyLevel2)
	delete_children($Props/SkyLevel3)
	delete_children($Props/SkyLevel4)
	delete_children($Props/AtmosLevel)
	delete_children($Props/AtmosLevel2)
	delete_children($Props/Space)

func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
