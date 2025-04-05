extends CharacterBody2D

@export var speed := 100
@export var direction_change_interval := 2.0  # seconds

var movement_rect: Rect2
var direction := Vector2.ZERO
var timer := 0.0

func _ready():
	pick_random_direction()
	
	var area_collision_shape = $Area2D/MovementArea
	var shape = area_collision_shape.shape
	
	if shape is RectangleShape2D:
		var size = shape.size
		var offset = area_collision_shape.position
		movement_rect = Rect2(global_position + offset - size * 0.5, size)

func _physics_process(delta):
	timer -= delta
	if timer <= 0:
		pick_random_direction()

	velocity = direction * speed
	move_and_slide()
	
	#if leaving movement area reverse direction
	if global_position.x < movement_rect.position.x or global_position.x > movement_rect.position.x + movement_rect.size.x:
		direction.x *= -1
		$Sprite2D.flip_h = direction.x < 0
		timer = randf_range(direction_change_interval * 0.5, direction_change_interval * 1.5)

func pick_random_direction():
	var dir = 0
	if randf() > 0.5:
		dir = 1
	else:
		dir = -1
	direction = Vector2(dir, 0)
	$Sprite2D.flip_h = dir < 0  # flip sprite if going left
	timer = randf_range(direction_change_interval * 0.5, direction_change_interval * 1.5)
