extends PowerUp
class_name GhostPowerUp

# Reference to the main game state
var main_game: Node = null

# Set this power-up to TURN_BASED
func _init():
	effect_type = EffectType.TURN_BASED
	defect = false  # This is a positive effect for the player
	icon = load("res://Assets/ghost_icon.png")
# Activate the power-up
func activate():
	if not main_game:
		print("Error: Main game reference not set!")
		return
	
	print(powerupOwner.name, " activated Ghost Power-Up! The cue ball will phase through opponent's balls for one turn.")
	enable_ghost_mode()

# Enable ghost mode by disabling collisions between the cue ball and opponent's balls
func enable_ghost_mode():
	if not main_game or not powerupOwner:
		print("Error: Main game or powerupOwner is not set!")
		return

	# Get the cue ball and opponent's balls
	var cue_ball = main_game.cue_ball
	var opponent_balls = get_opponent_balls()

	for ball in opponent_balls:
		var collision_shape = ball.get_node("CollisionShape2D")
		if collision_shape and cue_ball:
			# Disable collisions by setting collision_layer and collision_mask to 0
			collision_shape.disabled = true
			print("Collision disabled for", ball.name, "and cue ball.")

# Cleanup logic at the end of the turn
func on_turn_end():
	if not main_game:
		print("Error: Main game reference not set!")
		return

	print("Ghost Power-Up effect ended. Restoring collisions.")
	disable_ghost_mode()

# Restore collisions between the cue ball and opponent's balls
func disable_ghost_mode():
	if not main_game or not powerupOwner:
		print("Error: Main game or powerupOwner is not set!")
		return

	# Get the cue ball and opponent's balls
	var cue_ball = main_game.cue_ball
	var opponent_balls = get_opponent_balls()

	for ball in opponent_balls:
		var collision_shape = ball.get_node("CollisionShape2D")
		if collision_shape and cue_ball:
			# Re-enable collisions by restoring the collision state
			collision_shape.disabled = false
			print("Collision restored for", ball.name, "and cue ball.")

# Helper function to get the opponent's balls
func get_opponent_balls() -> Array:
	if powerupOwner.type == "solids" and main_game:
		return main_game.stripes
	elif powerupOwner.type == "stripes" and main_game:
		return main_game.solids
	else:
		print("Error: Player type not assigned or main game reference missing.")
		return []
