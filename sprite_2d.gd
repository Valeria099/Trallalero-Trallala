extends Sprite2D  # Assuming the spear is a Sprite

var spear_length = 100  # Set the length of your spear (in pixels)

func _ready():
	# This assumes the spear's pivot is at the top (for rotation to make sense)
	# If not, you can adjust the pivot using the 'Offset' in the Inspector
	pass

func _process(delta):
	# Get the mouse position in global coordinates
	var mouse_position = get_global_mouse_position()

	# Calculate the vector from the spear's top to the mouse position
	var spear_top_position = position  # Position of the spear's top (parent position)

	# Vector pointing from the spear's top to the mouse
	var direction_to_mouse = mouse_position - spear_top_position

	# Normalize the direction to get the angle
	var angle = direction_to_mouse.angle()

	# Set the rotation of the spear based on the calculated angle
	rotation = angle
