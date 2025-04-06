extends CharacterBody2D

@export var speed := 100
@export var direction_change := 100

var movement_rect: Rect2
var direction : Vector2 = Vector2.ZERO
var timer := 0.0

func _ready():
	pick_random_direction()


func _physics_process(delta):
	timer += 1
	if timer >= direction_change:
		pick_random_direction()
		timer = 0
	

	velocity = direction * speed
	move_and_slide()
	
	
	
func pick_random_direction():
	direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	if direction.x != 0:
		$Sprite2D.flip_h = direction.x < 0
