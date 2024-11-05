extends Sprite2D

signal shoot 
var power : float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	look_at(mouse_pos)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		power += 0.1
		
	else:
		if power > 0:
			var dir = mouse_pos + position
			shoot.emit(power * dir)
			power = 0
