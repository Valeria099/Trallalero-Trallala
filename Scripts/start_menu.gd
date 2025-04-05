extends Control

func startbutton():
	get_tree().change_scene_to_file("res://Scenes/hook.tscn")

func tutorialbutton():
	get_tree().change_scene_to_file("res://Scenes/tutorial_menu.tscn")

func quitbutton():
	get_tree().quit()
