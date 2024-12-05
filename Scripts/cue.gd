extends Sprite2D

signal shoot
var power: float = 0.0
var power_dir: int = 1

func _process(delta: float) -> void:
	var mouse_pos: Vector2 = $"../Pool_Table/Camera2D".get_global_mouse_position()
	look_at(mouse_pos)

	# Correctly reference the Main node
	var main_script = get_tree().root.get_node("Main")  # Ensure "Main" is the name of the root node

	if main_script and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not main_script.is_mouse_over_ui:
		power += 0.1 * power_dir
		if power >= get_parent().MAX_POWER:
			power_dir = -1
		elif power <= 0:
			power_dir = 1
	else:
		power_dir = 1
		if power > 0:
			var dir = mouse_pos - position
			emit_signal("shoot", -power * dir)
			power = 0
