extends Sprite2D

signal shoot 
var power : float = 0.0
var power_dir : int =1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos: Vector2 = $"../Pool_Table/Camera2D".get_global_mouse_position()
	look_at(mouse_pos)

	if get_tree().has_group("ui_blocking"):
		print("Blocking input due to ui_blocking group.")
		return
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		power += 0.1 * power_dir
		if power >= get_parent().MAX_POWER:
			power_dir = -1
		
		elif power <= 0:
			power_dir = 1
		
	else:
		power_dir = 1
		if power > 0:
			var dir = mouse_pos - position
			shoot.emit(-power * dir)
			power = 0
