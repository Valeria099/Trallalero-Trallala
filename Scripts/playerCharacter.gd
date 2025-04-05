extends CharacterBody2D

@export var move_speed : float = 100

# Define horizontal movement boundaries
const LEFT_LIMIT = 427
const RIGHT_LIMIT = 853

func _process(_delta):
	var direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	# Update Velocity
	velocity = direction * move_speed
	
	move_and_slide()
	# Clamp position so it stays in the center third of the screen
	#position.x = clamp(position.x, LEFT_LIMIT, RIGHT_LIMIT)
