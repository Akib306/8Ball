extends Node2D

# References for setting player nodes and power-up factory scene
#@export var player1_path: NodePath
#@export var player2_path: NodePath
@export var power_up_factory_scene: PackedScene

var rng = RandomNumberGenerator.new()

# Instance variable for the power-up factory
var power_up_factory: Node = null

# Enum to define power-ups
enum PowerUps { TELEPORT, WALL, MRBIG, TORNADO, REWIND, GHOST }


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Instantiate the power-up factory if the scene is assigned
	if power_up_factory_scene:
		power_up_factory = power_up_factory_scene.instantiate()
		add_child(power_up_factory)
	else:
		print("Warning: Power-up factory scene is not assigned.")

# Draw a power-up randomly and assign it to the specified player
func power_draw(player: Player) -> void:
	var rand_num = rng.randi_range(0, 10)
	if rand_num < 10:
		var power_up_instance = power_selector()
		if power_up_instance:
			player.add_to_inventory(power_up_instance)
			print(" Power-up added to ", player.name, "'s inventory")


# Select and assign a random power-up to the current player
func power_selector():
	print("Random power is being drawn...")
	#var rand_num = rng.randi_range(0, len(PowerUps) - 1)
	var rand_num = 1

	if power_up_factory:
		var power_up_instance = power_up_factory.power_up_factory(rand_num)
		if power_up_instance:
			return power_up_instance
		else:
			print("Warning: Failed to create power-up instance.")
			return null
	else:
		print("Warning: Power-up factory is not initialized.")
		return null
