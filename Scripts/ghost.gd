extends PowerUp
class_name GhostPowerUp

# Reference to the main game state
var main_game: Node = null

# Set this power-up to TURN_BASED
func _init():
	effect_type = EffectType.TURN_BASED
	defect = false  # This is a positive effect for the player
	icon = load("res://Assets/ghost_icon.png")
	name = "Ghost"
# Activate the power-up
func activate():
	if not main_game:
		print("Error: Main game reference not set!")
		return
	
	print(powerupOwner.name, " activated Ghost Power-Up! The cue ball will phase through opponent's balls for one turn.")
	enable_ghost_mode()

# Enable ghost mode by disabling collisions and changing opacity
func enable_ghost_mode():
	if not main_game or not powerupOwner:
		print("Error: Main game or powerupOwner is not set!")
		return

	# Get the cue ball and opponent's balls
	var cue_ball = main_game.cue_ball
	var opponent_balls = get_opponent_balls()

	# Change opacity of the cue ball
	if cue_ball:
		change_opacity(cue_ball, 0.5)  # Semi-transparent

	# Disable collisions and change opacity for opponent's balls
	for ball in opponent_balls:
		var collision_shape = ball.get_node("CollisionShape2D")
		if collision_shape:
			collision_shape.disabled = true  # Disable collisions
		change_opacity(ball, 0.5)  # Semi-transparent
		print("Collision disabled and opacity changed for", ball.name, "and cue ball.")

# Cleanup logic at the end of the turn
func on_turn_end():
	if not main_game:
		print("Error: Main game reference not set!")
		return

	print("Ghost Power-Up effect ended. Restoring collisions and opacity.")
	disable_ghost_mode()

# Restore collisions and opacity
func disable_ghost_mode():
	if not main_game or not powerupOwner:
		print("Error: Main game or powerupOwner is not set!")
		return

	# Get the cue ball and opponent's balls
	var cue_ball = main_game.cue_ball
	var opponent_balls = get_opponent_balls()

	# Restore opacity of the cue ball
	if cue_ball:
		change_opacity(cue_ball, 1.0)  # Fully opaque

	# Re-enable collisions and restore opacity for opponent's balls
	for ball in opponent_balls:
		var collision_shape = ball.get_node("CollisionShape2D")
		if collision_shape:
			collision_shape.disabled = false  # Re-enable collisions
		change_opacity(ball, 1.0)  # Fully opaque
		print("Collision restored and opacity reset for", ball.name, "and cue ball.")

# Helper function to change opacity
func change_opacity(ball: Node, opacity: float):
	var sprite_node = ball.get_node("Sprite2D")
	if sprite_node:
		var modulate_color = sprite_node.modulate
		modulate_color.a = opacity  # Set alpha channel
		sprite_node.modulate = modulate_color

# Helper function to get the opponent's balls
func get_opponent_balls() -> Array:
	if powerupOwner.type == "solids" and main_game:
		return main_game.stripes
	elif powerupOwner.type == "stripes" and main_game:
		return main_game.solids
	else:
		print("Error: Player type not assigned or main game reference missing.")
		return []
