extends CharacterBody2D

@export var move_speed : float = 100
@onready var grab_zone = $GrabZone
@onready var hand = $Hand

var weight = false



func _process(_delta):
	var direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	)
	look_at(get_global_mouse_position())

	# Update Velocity
	velocity = direction * move_speed
	
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
