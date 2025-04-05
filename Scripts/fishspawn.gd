extends Node2D

@export var fish_scene: PackedScene
@export var fish_limit := 5

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	$FishTimer.start()

func spawn_fish():
	if get_child_count() >= fish_limit + 1:
		return
	var fish = fish_scene.instantiate()
	var screen_size = get_viewport_rect().size
	
	#random position anywhere on the screen
	fish.global_position = Vector2(
		randf_range(0, screen_size.x),
		randf_range(0, screen_size.y)
		)
	
	add_child(fish)
	
func _on_timer_timeout():
	spawn_fish()
