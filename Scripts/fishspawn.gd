extends Node2D

@export var fish_scene: PackedScene
@export var fish_limit := 500

@export var world_width: float = 900      # Map width
@export var world_depth: float = 2500     # Map depth (Y-axis)
@export var min_scale: float = 0.5        # Smallest fish size
@export var max_scale: float = 2.0        # Largest fish size

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	$FishTimer.start()

func spawn_fish():
	if get_child_count() >= fish_limit + 1:
		return
	
	var fish = fish_scene.instantiate()
	var spawn_y = randf_range(0, world_depth)
	
	fish.global_position = Vector2(
		randf_range(-831, 991),
		spawn_y
	)
	
	# Calculate weight (0-100) based on depth
	var weight = (spawn_y / world_depth) * 100
	fish.set("weight", weight)
	
	# Apply scaling based on weight
	scale_fish(fish, weight)
	add_child(fish)

func _on_timer_timeout():
	spawn_fish()

func scale_fish(fish: Node2D, weight: float):
	var scale_factor = lerp(min_scale, max_scale, weight / 100)
	fish.scale = Vector2(scale_factor, scale_factor)
