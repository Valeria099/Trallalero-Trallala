extends Node2D

@export var fish_scene: PackedScene
@export var fish_limit := 40
@export var spawn_interval: float = 0.5
@export var base_points := 10  # Optional base value if needed

var spawn_timer: Timer
var spawn_shape: CollisionShape2D
func _ready():
	spawn_shape = $Spawn
	spawn_timer = $Timer
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_timer_timeout)
	spawn_timer.start()
	var _fish = load("res://Scenes/Character/fish.tscn").instantiate()

	
func spawn_fish():
	if get_child_count() >= fish_limit + 1:
		return
	var fish = load("res://Scenes/Character/fish.tscn").instantiate()
	var screen_size = get_viewport_rect().size
	
	#random position anywhere on the screen
	fish.global_position = Vector2(
		randf_range(0, 300),
		randf_range(100, 2000)
		)
		
	var y_position = fish.global_position.y
	print("Spawned fish at y position: ", y_position)
	
	var x_ratio = y_position / screen_size.x  # value between 0.0 and 1.0
	var min_scale = 0.5
	var max_scale = 2.0
	var scale_factor = lerp(min_scale, max_scale, x_ratio)
	fish.scale = Vector2(scale_factor, scale_factor)
	var points = fish.scale * 5
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
