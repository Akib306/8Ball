extends PowerUp
class_name MrBigPowerUp

# Reference to the main game state (passed in during activation)
var main_game: Node = null

# Set this power-up to TURN_BASED
func _init():
	effect_type = EffectType.TURN_BASED

# Activate the power-up
func activate():
	if not main_game:
		print("Error: Main game reference not set!")
		return
	
	print(owner.name, " used MrBig!")
	#enlarge_opponent_balls()

# Logic to enlarge opponent's balls
func enlarge_opponent_balls():
	print("Enlarging opponent's balls...")
	var opponent_balls = get_opponent_balls()
	for ball in opponent_balls:
		var sprite_node = ball.get_node("Sprite2D")
		var collision_node = ball.get_node("CollisionShape2D")
		sprite_node.scale *= 1.5  # Enlarge sprite
		collision_node.scale *= 1.5  # Adjust collision shape
		ball.add_to_group("enlarged_balls")  # Tag for tracking
		print("Ball", ball.name, "enlarged.")

# Cleanup logic at the end of the owner's turn
func on_turn_end():
	if not main_game:
		print("Error: Main game reference not set!")
		return
	
	print("MrBig effect ended.")
	#restore_ball_sizes()

# Restore the original sizes of the opponent's balls
func restore_ball_sizes():
	for ball in get_tree().get_nodes_in_group("enlarged_balls"):
		var sprite_node = ball.get_node("Sprite2D")
		var collision_node = ball.get_node("CollisionShape2D")
		sprite_node.scale /= 1.5  # Restore sprite size
		collision_node.scale /= 1.5  # Restore collision shape size
		ball.remove_from_group("enlarged_balls")  # Remove tracking tag
		print("Ball", ball.name, "restored to original size.")

# Helper function to get the opponent's balls
func get_opponent_balls() -> Array:
	if owner.type == "solids" and main_game:
		return main_game.stripes
	elif owner.type == "stripes" and main_game:
		return main_game.solids
	else:
		print("Error: Player type not assigned or main game reference missing.")
		return []
