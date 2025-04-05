extends Node2D

@export var fish_scene: PackedScene
@export var fish_limit := 500

@export var world_width: float = 900  # Your map's total width
@export var world_depth: float = 5000  # Your map's total depth (Y-axis)

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	$FishTimer.start()

func spawn_fish():
	var fish = fish_scene.instantiate()
	
	# Spawn from top (Y=0) to bottom (Y=world_depth)
	var spawn_y = randf_range(0, world_depth)  
	
	fish.global_position = Vector2(
		randf_range(0, world_width),  # Full map width
		spawn_y                      # Full map depth
	)
	
	# Weight increases with depth (0-100)
	var weight = (spawn_y / world_depth) * 100  
	fish.set("weight", weight)
	
	add_child(fish)
	
func _on_timer_timeout():
	spawn_fish()
	
# Calculate weight based on Y position (the deeper, the heavier)
func calculate_fish_weight(y_position: float) -> float:
   
	var weight = (y_position / get_viewport_rect().size.y) * 100  # Example, weights range from 0 to 100
	return weight	
	
func scale_fish(fish: Node2D, weight: float):
	# Adjust the scale factor: the higher the weight, the larger the scale
	var scale_factor = lerp(0.5, 2.0, weight / 100)  # Scale between 0.5 and 2.0 based on weight (adjust as needed)
	
	fish.scale = Vector2(scale_factor, scale_factor)
