extends CharacterBody2D

@export var move_speed : float = 100
const PIXELS_PER_METER = 64  # 64px = 1 meter (adjust to match your game scale)

@onready var depth_label = $Camera2D/UI/DepthCounter  # Adjust path if needed

func _process(_delta):
	# Movement
	var direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	look_at(get_global_mouse_position())
	velocity = direction * move_speed
	move_and_slide()
	
	# Update depth display (in meters)
	var depth_meters = int(global_position.y / PIXELS_PER_METER)
	depth_label.text = "Depth: %dm" % depth_meters
