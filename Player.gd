extends KinematicBody2D

signal dive_status()
signal hover_status()

var speed = 10.0

export(float, 1.0, 500.0) var hover_magnitude: float = 200.0
export(float, 1.0, 5.0) var diving_factor: float = 2.0
export var jump_strength: float = 500.0
var launch_dt = 0.0
var gravity = 9.8
var deaccel = 10.0
var propulsion_vel = 12000.0

enum PlayerState {
	Ready
	Launching,
	Flying,
	Pause
}

var state = PlayerState.Ready
var hovering = false
export var hover_modifier: float = 1.3

var velocity: Vector2 = Vector2(0, 0)
export var terminal_vertical_vel = 800.0
export var terminal_horizontal_vel = 1000.0
var current_terminal_vel_x = terminal_horizontal_vel
var jump = false
var can_hover = true
var diving = false
var can_dive = true

func _process(delta):
	match state:
		PlayerState.Ready:
			if Input.is_action_just_pressed("launch_bird"):
				state = PlayerState.Launching
		PlayerState.Launching:
			launch_dt += delta
			if Input.is_action_just_released("launch_bird"):
				launch()
				state = PlayerState.Flying
		PlayerState.Flying:
			if Input.is_action_just_pressed("Hover") && velocity.y > 0 && can_hover:
				hovering = true
				can_hover = false
				$HoverTimer.start()
			if Input.is_action_just_released("Hover"):
				$HoverTimer.stop()
				stop_hovering()
			if Input.is_action_just_pressed("Dive") && velocity.y > 0 && can_dive:
				emit_signal("dive_status", false)
				diving = true
				can_dive = false
				$DiveTimer.start()
				
			if Input.is_action_just_pressed("ui_cancel"):
				state = PlayerState.Pause
		PlayerState.Pause:
			if Input.is_action_just_pressed("ui_cancel"):
				state = PlayerState.Flying
				

func _physics_process(delta):
	
	if state == PlayerState.Pause:
		return
	
	var gravity_to_apply = gravity


	if state == PlayerState.Flying:
		velocity.y = gravity_to_apply + velocity.y
		
	if hovering:
		velocity.y /= 2.0
	if diving:
		velocity = jump_strength * Vector2(5,1).normalized()
		diving = false
	
	velocity.y = min(velocity.y, terminal_vertical_vel)
	
	
	if velocity.x > current_terminal_vel_x:
		velocity.x = lerp(velocity.x, current_terminal_vel_x, delta * deaccel)

	
	if is_on_floor():
		velocity.x *= 0.95
		if velocity.y > 0:
			velocity.y = -0.9*abs(velocity.y)

	var vel_before = velocity
	velocity = move_and_slide(vel_before, Vector2.UP)
	
	# REBOUND !!!
	if get_slide_count() > 0:
		var collision = get_slide_collision(0)
		if collision != null:
			velocity.y = -0.7*vel_before.y
	
	
func launch():
	velocity = Vector2(1.0, -1.0) * 500.0 * clamp(launch_dt, 1.0, 10.0)
	
func on_jump():
	""" To apply when the player encounters a jump pad. Only jump if player is falling down
	"""
	if velocity.y > 0.0:
		velocity.y = -jump_strength * 7.0
		velocity.x += jump_strength
		

func bird_collision():
	velocity *= 0.9
	
func propulsion():
	velocity.x = propulsion_vel
	current_terminal_vel_x = propulsion_vel
	yield(get_tree().create_timer(2.0), "timeout")
	current_terminal_vel_x = terminal_horizontal_vel

func stop_hovering():
	if hovering:
		hovering = false
		emit_signal("hover_status", false)
		yield(get_tree().create_timer(2.0), "timeout")
		can_hover = true
		emit_signal("hover_status", true)

func _on_HoverTimer_timeout():
	stop_hovering()

func _on_DiveTimer_timeout():
	can_dive = true
	emit_signal("dive_status", true)
	
func reset():
	state = PlayerState.Ready
	velocity = Vector2(0,0)
	position = Vector2(100,1024)
	launch_dt = 0.0
