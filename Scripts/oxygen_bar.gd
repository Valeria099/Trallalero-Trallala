class_name OxygenBar
extends CanvasLayer

@export var oxygen_ratio := 1.0:
	set(value):
		oxygen_ratio = clampf(value, 0.0, 1.0)
		update_oxygen_display()
		update_warning_effect()

@export var low_oxygen_threshold := 0.3
@export var normal_color := Color(0.2, 0.8, 0.4) # bright green
@export var warning_color := Color(1, 0.3, 0.3) # red

@onready var bar_fill := $Control/MarginContainer/VBoxContainer/HBoxContainer/TextureProgressBar as TextureProgressBar
@onready var oxygen_label := $Control/MarginContainer/VBoxContainer/Label as Label
@onready var animation_player := $Control/AnimationPlayer as AnimationPlayer

func _ready():
	# trying to lock oxygen bar to top left
	var ui_root = get_node("Control")
	ui_root.set_anchors_preset(Control.PRESET_TOP_LEFT)
	ui_root.offset_top = 20
	ui_root.offset_left = 20
	ui_root.show()
	
	bar_fill.max_value = 100
	bar_fill.value = oxygen_ratio * 100
	bar_fill.fill_mode = TextureProgressBar.FILL_BOTTOM_TO_TOP
	update_oxygen_display()
	update_warning_effect()

func update_oxygen_display():
	if not bar_fill:
		return
	bar_fill.value = oxygen_ratio * 100
	
	if oxygen_ratio < low_oxygen_threshold:
		bar_fill.tint_progress = warning_color
	else:
		bar_fill.tint_progress = normal_color

func update_warning_effect():
	if not is_instance_valid(animation_player) or not is_instance_valid(oxygen_label):
		return
	if oxygen_ratio < low_oxygen_threshold:
		if not animation_player.is_playing():
			animation_player.play("low_oxygen_pulse")
	else:
		animation_player.stop()
		oxygen_label.modulate = Color.WHITE
		bar_fill.tint_progress = normal_color

func update_oxygen(ratio: float):
	oxygen_ratio = clampf(ratio, 0.0, 1.0)
