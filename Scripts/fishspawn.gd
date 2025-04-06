extends Node2D

@export var fish_scene: PackedScene
@export var fish_limit := 40
@export var spawn_interval: float = 1.0

var spawn_timer: Timer
var spawn_shape: CollisionShape2D
func _ready():
	spawn_shape = $CollisionShape2D
	spawn_timer = $Timer
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_timer_timeout)
	spawn_timer.start()
	var fish = load("res://Scenes/Character/fish.tscn").instantiate()

	
func spawn_fish():
	if get_child_count() >= fish_limit + 1:
		return
	var fish = load("res://Scenes/Character/fish.tscn").instantiate()
	var screen_size = get_viewport_rect().size
	
	#random position anywhere on the screen
	fish.global_position = Vector2(
		randf_range(0, screen_size.x),
		randf_range(0, screen_size.y)
		)
	
	add_child(fish)
	
func _on_timer_timeout():
	spawn_fish()
	if not fish_scene:
		print("No enemy scene assigned!")
		return
	var enemy = fish_scene.instantiate()
	var spawn_position = get_random_point_in_shape()
	enemy.global_position = spawn_position
	get_tree().current_scene.add_child(enemy)

func get_random_point_in_shape() -> Vector2:
	var shape = spawn_shape.shape
	if shape is RectangleShape2D:
		var extents = shape.extents
		var local_pos = Vector2(
			randf_range(-extents.x, extents.x),
			randf_range(-extents.y, extents.y)
			)
		return to_global(local_pos)
	elif shape is CircleShape2D:
		var r = shape.radius * sqrt(randf())
		var angle = randf() * TAU
		var local_pos = Vector2(r * cos(angle), r * sin(angle))
		return to_global(local_pos)
	else:
		push_warning("Unsupported shape type!")
		return global_position
