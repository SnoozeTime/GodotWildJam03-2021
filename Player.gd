extends KinematicBody2D

signal add_money()
signal game_over()
signal used_rocket()
signal used_helmet()

var speed = 10.0

# Launching
export(float, 0.0, 180.0) var max_launch_angle: float = 60
var launch_direction_counter = 0.0
var power_direction_counter = 0.0
export var launch_strength = 20.0


export(float, 1.0, 500.0) var hover_magnitude: float = 200.0
export(float, 1.0, 5.0) var diving_factor: float = 2.0
export var jump_strength: float = 200.0

var gravity = 9.8
var deaccel = 10.0
var propulsion_vel = 8000.0

enum PlayerState {
	Buying,
	Ready,
	Launching_Direction,
	Launching_Power,
	Flying,
	Pause,
	Caged,
	Dying
}

onready var animator = $AnimationPlayer

func set_ready():
	state = PlayerState.Ready

var state = PlayerState.Buying
var hovering = false
export var hover_modifier: float = 1.3

var velocity: Vector2 = Vector2(0, 0)
#export var terminal_vertical_vel = 2800.0
#export var terminal_horizontal_vel = 1000.0
#var current_terminal_vel_x = terminal_horizontal_vel

const STOPPED_VEL = 20
const MAX_GENKINESS = 100.0
# How much energy. Refill over time. flapping wings exhaust some energy.
var genkiness = MAX_GENKINESS
var flap_consumption = 30.0
export(float, 1.0, 10.0) var genkiness_restore_rate = 5.0 # per second
export(float, 300.0, 1000.0) var flap_strength = 500.0


var has_helmet = false
var has_rocket = false
var has_wings = false


func _ready():
	update_launcher_sprite()
		
func show_flying_sprite():
	$Sprite.show()
	$cannon.hide()

func update_launcher_sprite():
	if Save.upgrade_level > 0:
		$Sprite.hide()
		$cannon.show()
	else:
		$Sprite.show()
		$cannon.hide()
		
func get_cannon_sprite():
	if Save.upgrade_level>0:
		return $cannon
	else:
		return $LaunchSprites/DirectionGauge
		
func get_cannon_power():
	match Save.upgrade_level:
		0:
			return launch_strength
		1:
			return launch_strength*1.5
		_:
			return launch_strength*2.0

func update_inventory(inventory):
	has_helmet = inventory["helmet"]
	has_rocket = inventory["rocket"]
	has_wings = inventory["wings"]

func can_flap() -> bool:
	return genkiness - flap_consumption >= 0 && velocity.y > 0
	
func flap() -> void:
	if can_flap():
		var flap_str = -flap_strength
		if has_wings:
			flap_str *= 2
		velocity.y = flap_str
		animator.play("Jump")
		genkiness -= flap_consumption

func _process(delta):
	match state:
		PlayerState.Ready:
			if Input.is_action_just_pressed("launch_bird"):
				state = PlayerState.Launching_Direction
				if Save.upgrade_level == 0:
					$LaunchSprites/DirectionGauge.show()
		PlayerState.Launching_Direction:
			launch_direction_counter += delta * PI/4
			get_cannon_sprite().rotation = deg2rad(max_launch_angle) * sin(launch_direction_counter)
			if Input.is_action_just_released("launch_bird"):
				state = PlayerState.Launching_Power
				$LaunchSprites/DirectionGauge.hide()
				$LaunchSprites/PowerGauge.show()
		PlayerState.Launching_Power:
			power_direction_counter += delta * PI/4
			$LaunchSprites/PowerGauge/TextureProgress.value = 100 * (sin(power_direction_counter)+1)/2
			if Input.is_action_just_pressed("launch_bird"):
				launch()
				state = PlayerState.Flying
				$LaunchSprites/PowerGauge.hide()
				show_flying_sprite()
		PlayerState.Flying:
			genkiness = min(MAX_GENKINESS, genkiness + delta * genkiness_restore_rate)
			if Input.is_action_just_pressed("ui_cancel"):
				state = PlayerState.Pause
				
			if velocity.length_squared() < STOPPED_VEL:
				state = PlayerState.Dying
				emit_signal("game_over")
		PlayerState.Pause:
			if Input.is_action_just_pressed("ui_cancel"):
				state = PlayerState.Flying
				

func _physics_process(delta):
	
	if state != PlayerState.Flying:
		return
	
	var gravity_to_apply = gravity

	if state == PlayerState.Flying:
		velocity.y = gravity_to_apply + velocity.y
	
	if Input.is_action_just_pressed("Jump"):
		flap()
	
	if has_rocket && Input.is_action_just_pressed("Rocket"):
		propulsion()
		has_rocket = false
		emit_signal("used_rocket")
	
	# Slow down on floor
	if is_on_floor():
		velocity.x *= 0.95

	var vel_before = velocity
	velocity = move_and_slide(vel_before, Vector2.UP)
	
	# REBOUND !!!
	if get_slide_count() > 0:
		var collision = get_slide_collision(0)
		if collision != null:
			velocity.y = -0.7*vel_before.y
	
	
func launch():
	var direction = Vector2.RIGHT.rotated(get_cannon_sprite().rotation)
	velocity = direction * $LaunchSprites/PowerGauge/TextureProgress.value * get_cannon_power()
	
func on_jump(impulse):
	""" To apply when the player encounters a jump pad. 
	"""
	velocity.x += impulse.x
	velocity.y = impulse.y

func bird_collision():
	velocity.x *= 0.5
	velocity.y *= 0.9
	
func propulsion():
	velocity.x = propulsion_vel
	velocity.y = -1.0

func reset(pos):
	state = PlayerState.Buying
	velocity = Vector2(0,0)
	position = pos
	show()

func caught_in_cage():
	if has_helmet:
		emit_signal("used_helmet")
		has_helmet = false
	else:
		velocity = Vector2.ZERO
		state = PlayerState.Caged
		hide()
		# wait a bit to show the player in the cage. because it's fun
		yield(get_tree().create_timer(1.0), "timeout")
		emit_signal("game_over")
	
func add_money(amt):
	emit_signal("add_money", amt)

