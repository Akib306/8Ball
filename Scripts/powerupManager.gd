extends Node
class_name PowerUpManager

# Random Number Generator for random power-ups
var rng = RandomNumberGenerator.new()
var main_game: Node = null  # Reference to main.gd

# Reference to the power-up factory
@export var power_up_factory: Node = null

# Dictionary to track active turn-based power-ups per player
var active_power_ups: Dictionary = {}  # {Player: PowerUp}

func set_main_game(main: Node):
	main_game = main
# Activate a power-up for a player
func activate_power_up(player: Player, power_up: PowerUp) -> void:
	power_up.powerupOwner = player
	power_up.activate()

	if power_up.effect_type == PowerUp.EffectType.TURN_BASED:
		# Add turn-based power-ups to tracking
		active_power_ups[player] = power_up
		print("Turn-based power-up activated for ", player.name)

# Handle end of a player's turn
func on_turn_end(player: Player) -> void:
	if active_power_ups.has(player):
		var power_up = active_power_ups[player]
		power_up.on_turn_end()  # Call cleanup logic for the power-up
		active_power_ups.erase(player)  # Remove it after turn ends
		print("Turn-based power-up ended for ", player.name)

# Randomly draw a power-up and assign it to the player
func power_draw(player: Player) -> void:
	var power_up = power_selector()
	if power_up:
		player.add_to_inventory(power_up)
		print("Random power-up added to ", player.name, "'s inventory:", power_up)

# Select a random power-up using the factory
func power_selector() -> PowerUp:
	if not power_up_factory:
		print("Error: No power-up factory assigned.")
		return null

	print("Random power-up is being drawn...")
	var power_up_type = rng.randi_range(0, PowerUpFactory.get_total_power_ups() - 1)
	var power_up_instance = power_up_factory.create_power_up(power_up_type)

	if power_up_instance:
		return power_up_instance
	else:
		print("Error: Failed to create power-up instance.")
		return null
