extends Node2D

@export var cue_ball: Node2D  # Cue ball is exported and assigned dynamically

func _draw() -> void:
	if not cue_ball:
		print(cue_ball)
		return

	var length = 1200  # Length of the line
	
	# Get the cue ball's position as the starting point
	var start = cue_ball.global_position - get_parent().global_position  # Convert to local space
	start.x -= 1000
	# Calculate the end point based on the cue stick's rotation
	var end = start + Vector2(length * cos(rotation), length * sin(rotation))  # Extend outward
	
	 #Draw the line
	draw_line(start, end, Color.RED, 8, true)



func _process(delta: float) -> void:
	if not cue_ball:
		return
		
	queue_redraw()

	## Reference the parent (Cue)
	#var cue = get_parent()
#
	## Match the position of the Cue
	#global_position = cue.global_position
#
	## Use look_at to point in the direction of the cue stick
	#var direction = cue.global_position + Vector2(cos(cue.rotation), sin(cue.rotation)) * 100
	#look_at(direction)
