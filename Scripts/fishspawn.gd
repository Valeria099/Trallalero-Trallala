extends Node2D

@export var fish_scene: PackedScene
@export var fish_limit := 10

var rng = RandomNumberGenerator.new()

func _ready():
	add_to_group("fish")  # Force add on spawn
	if is_in_group("player"):
		remove_from_group("player")  # Cleanup
	rng.randomize()
	$FishTimer.start()

func spawn_fish():
	if get_child_count() >= fish_limit + 1:
		return
	var new_fish = fish_scene.instantiate()
	new_fish.add_to_group("fish")  # Explicitly add to group
	new_fish.remove_from_group("player")  # Remove inherited group
	var screen_size = get_viewport_rect().size
	
	#random position anywhere on the screen
	new_fish.global_position = Vector2(
		randf_range(0, screen_size.x),
		randf_range(0, screen_size.y)
		)
	get_parent().add_child(new_fish)  # Add to scene root, not Fishspawn
	
func _on_timer_timeout():
	spawn_fish()
