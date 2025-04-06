extends CharacterBody2D

func caught_by_spear():
	print("Fish caught!")
	$CollisionShape2D.set_deferred("disabled", true)
	visible = false
	
	await get_tree().create_timer(0.5).timeout
	
	queue_free()
	emit_signal("fish_caught")
