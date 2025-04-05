extends Sprite2D

var speed = 600

# Define horizontal movement boundaries
const LEFT_LIMIT = 427
const RIGHT_LIMIT = 853

func _process(delta):
	var direction = 0

	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		direction -= 1
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		direction += 1

	# Move
	position.x += direction * speed * delta

	# Clamp position so it stays in the center third of the screen
	position.x = clamp(position.x, LEFT_LIMIT, RIGHT_LIMIT)
