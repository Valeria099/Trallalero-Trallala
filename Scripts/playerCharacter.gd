extends CharacterBody2D

# fish catching w spear
@export var spear: Sprite2D
@export var spear_area: Area2D
@export var spear_attack_distance: float = 50.0
@export var spear_attack_speed: float = 10.0

var is_attacking = false
var spear_original_position: Vector2
var fish_caught = 0

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
	
	spear_original_position = spear.position
	spear_area.monitoring = false #disable until attack
	
	print("Fish groups:", get_groups())  # Should print ["fish"]

func _input(event):
	if event.is_action_pressed("left_click") and not is_attacking:
		attack_with_spear()

func attack_with_spear():
	is_attacking = true
	spear_area.monitoring = true # enable collision detection
	
	# animate spear thrust (move forward)
	var target_position = spear_original_position + Vector2(spear_attack_distance, 0)
	var tween = create_tween()
	tween.tween_property(spear, "position", target_position, 0.1)
	tween.tween_property(spear, "position", spear_original_position, 0.3)
	tween.tween_callback(_finish_attack)

func _finish_attack():
	is_attacking = false
	spear_area.monitoring = false

func _on_spear_area_body_entered(body):
	print("entered")
	# Skip if colliding with player
	var node = body
	while node != null:
		if "fish" in node.get_groups():
			print("caught fish")
			node.caught_by_spear()
			fish_caught += 1
			return
		node = node.get_parent()

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
