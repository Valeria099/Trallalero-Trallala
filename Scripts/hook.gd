extends Sprite2D

var speed = 600

const LEFT_LIMIT = 427
const RIGHT_LIMIT = 853

func _process(delta):
	var direction = 0
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		direction -= 1
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		direction += 1

	position.x += direction * speed * delta
	
	position.x = clamp(position.x, LEFT_LIMIT, RIGHT_LIMIT)
