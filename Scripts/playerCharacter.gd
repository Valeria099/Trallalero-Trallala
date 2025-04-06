extends CharacterBody2D

# oxygen system
@export var oxygen_ui: OxygenBar
@export var max_oxygen := 100.0
var current_oxygen := 100.0
@export var oxygen_depletion_rate := 10.0
@export var oxygen_replenish_rate := 15.0

@export var jump_force = 600
@export var move_speed : float = 350
@export var swim_speed = 300
@export var gravity = 400
@export var max_fall_speed = 2000

var is_swimming = false
var is_jumping = false

func _ready():
	current_oxygen = max_oxygen

func _process(delta):
	# Make the character always face the mouse cursor
	look_at(get_global_mouse_position())
	
	# oxygen management
	if is_swimming:
		current_oxygen = max(current_oxygen - (oxygen_depletion_rate * delta), 0)
		if current_oxygen <= 0:
			drown()
	else:
		current_oxygen = min(current_oxygen + (oxygen_replenish_rate * delta), max_oxygen)
		
	# Update UI if reference exists
	if oxygen_ui:
		oxygen_ui.update_oxygen(current_oxygen / max_oxygen)

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

func set_swimming(swimming: bool):
	is_swimming = swimming
	if !swimming:
		is_jumping = false

func drown(): # waits for a sec and goes game over screen
	await get_tree().create_timer(1.0).timeout
	
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

func refill_oxygen(amount: float):
	current_oxygen = min(current_oxygen + amount, max_oxygen)
