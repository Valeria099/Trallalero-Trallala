extends CharacterBody2D

@export var jump_force = 600
@export var move_speed : float = 450
@export var swim_speed = 400
@export var gravity = 400
@export var max_fall_speed = 2000
@onready var grab_zone = $GrabZone

var weight = false
var is_swimming = false
var is_jumping = false

func _process(_delta):
	# Make the character always face the mouse cursor
	look_at(get_global_mouse_position())

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	if is_swimming:
		# Swimming movement - full directional control
		input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
		velocity = input_vector.normalized() * swim_speed
		
		# Jump out of water
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_force
			is_jumping = true
	else:
		# Air/land movement - horizontal control only with gravity
		input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		velocity.x = input_vector.x * move_speed
		
		# Apply gravity
		velocity.y += gravity * delta
		velocity.y = clamp(velocity.y, -max_fall_speed, max_fall_speed)
	
	move_and_slide()
	# Clamp position so it stays in the center third of the screen
	#position.x = clamp(position.x, LEFT_LIMIT, RIGHT_LIMIT)
	if Input.is_action_just_pressed("grab_fish"):
		var areas = $GrabZone.get_overlapping_areas()
		print("Overlapping Areas:", areas)
		for area in areas:
			print("Found area: ", area.name)

func try_pickup():
	for body in $GrabZone.get_overlapping_bodies():
		if body is CharacterBody2D and body.get_parent().has_method("on_picked_up"):
			var fish = body.get_parent()
			if fish.can_be_picked_up():
				fish.on_picked_up()
				return

func _on_fish_picked_up():
	weight = true

func set_swimming(swimming: bool):
	is_swimming = swimming
	if !swimming:
		is_jumping = false
