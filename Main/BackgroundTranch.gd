extends Node2D


const PLACE_CAGE_PROB = 20;
const MAX_NUMBER_OF_MOVING_JUMPS = 2
const MOVING_JUMPS_PROB = 30
const ROCKET_PROB = 40;
var number_of_birds = 4
const BIRD_PROB = 50
const MONEY_AROUND_GROUND = 10
const BALLOON_PROB = 30

var cage_scene = preload("res://Main/Cage.tscn")
var moving_jump_scene = preload("res://Main/Cow.tscn")
var rocket_scene = preload("res://Main/Propulsion.tscn")
var bird_scene = preload("res://Main/AssholeBird.tscn")
var money_scene = preload("res://Main/MoneyBag.tscn")
var balloon_scene = preload("res://Main/Balloon.tscn")

func generate_props():
	""" Add new props (jumps and so on) in the tranch. 
	"""
	
	# GROUND LEVEL. Cage, moving jumps and so on.
	delete_children($Props/GroundLevel)
	if roll(PLACE_CAGE_PROB):
		var cage = cage_scene.instance()
		$Props/GroundLevel.add_child(cage)
		cage.position.x = rand_range(-1000, 1000)
		cage.position.y = -100
		
	for _i in (MAX_NUMBER_OF_MOVING_JUMPS):
		if roll(MOVING_JUMPS_PROB):
			var jump = moving_jump_scene.instance()
			$Props/GroundLevel.add_child(jump)
			jump.position.x = rand_range(-1000, 1000)
	if roll(MONEY_AROUND_GROUND):
		var money = money_scene.instance()
		$Props/GroundLevel.add_child(money)
		money.position.x = rand_range(-1000, 1000)
		money.position.y = rand_range(-1000, 0)
			
			
	# SKY LEVEL. Birds!!! Rockets !!!
	delete_children($Props/SkyLevel)
	if roll(ROCKET_PROB):
		var rocket = rocket_scene.instance()
		$Props/SkyLevel.add_child(rocket)
		rocket.position = Vector2(rand_range(-1024, 1024),rand_range(-1024, 1024))
	for _i in (number_of_birds):
		if roll(BIRD_PROB):
			var bird = bird_scene.instance()
			$Props/SkyLevel.add_child(bird)
			bird.position.x = 1024
			bird.position.y = rand_range(-1024, 1024)
	if roll(BALLOON_PROB):
		var balloon = balloon_scene.instance()
		$Props/SkyLevel.add_child(balloon)
		balloon.position = Vector2(rand_range(-1024, 1024),rand_range(0, 1024))
			
func roll(percent) -> bool:
	return (randi() % 100) <= percent
	
func reset(p):
	position = p
	delete_children($Props/GroundLevel)
	delete_children($Props/SkyLevel)

func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
