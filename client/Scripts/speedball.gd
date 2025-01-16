extends PowerUp
class_name SpeedBallPowerUp

# Reference to the main game state (passed in during activation)
var main_game: Node = null

# Store the original power factor for restoration
var original_power_factor: float = 1.0

# Set this power-up to TURN_BASED and make it a defect
func _init():
	effect_type = EffectType.TURN_BASED
	icon = load("res://Assets/speed_ball_icon.png")  # Replace with actual icon path
	defect = true
	name = "Speed ball"
# Activate the power-up
func activate():
	if not main_game:
		print("Error: Main game reference not set!")
		return

	# Identify the opponent and the cue
	var opponent_player = main_game.player2 if powerupOwner == main_game.player1 else main_game.player1
	var cue = main_game.cue
	
	if not cue:
		print("Error: Cue is not set in main_game!")
		return

	# Save the original power factor
	original_power_factor = cue.powerfactor

	# Increase the power factor for the opponent's cue
	cue.powerfactor *= 50  # Adjust multiplier as needed
	print(opponent_player.name, "'s cue power factor increased to:", cue.powerfactor)

# Cleanup logic at the end of the powerupOwner's turn
func on_turn_end():
	if not main_game:
		print("Error: Main game reference not set!")
		return

	# Reset the cue's power factor
	var cue = main_game.cue
	if cue:
		cue.powerfactor = original_power_factor
		print("Cue power factor reset to:", cue.powerfactor)
	else:
		print("Error: Cue is not set in main_game during cleanup!")
