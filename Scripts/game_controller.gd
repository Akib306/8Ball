extends Node2D

# References for setting player nodes and power-up factory scene
@export var player1_path: NodePath
@export var player2_path: NodePath
@export var power_up_factory_scene: PackedScene

var rng = RandomNumberGenerator.new()

# Instance variable for the power-up factory
var power_up_factory: Node = null

# Enum to define power-ups
enum PowerUps { TELEPORT, WALL, MRBIG, TORNADO, REWIND, GHOST }

# Player instances
var player1: Player
var player2: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize Player objects directly, since they are not Nodes
	player1 = Player.new("Player 1", true)
	player2 = Player.new("Player 2", false)

	# Connect the power-up event
	get_parent().connect("power_gamble", Callable(self, "power_draw"))
	
	# Instantiate the power-up factory if the scene is assigned
	if power_up_factory_scene:
		power_up_factory = power_up_factory_scene.instantiate()
		add_child(power_up_factory)
	else:
		print("Warning: Power-up factory scene is not assigned.")

# Draw a power-up randomly
func power_draw() -> void:
	var rand_num = rng.randi_range(0, 10)
	print("Random number drawn:", rand_num)
	if rand_num < 4: 
		power_selector()

# Select and assign a random power-up to the current player
func power_selector():
	print("Random power is being drawn...")
	var rand_num = rng.randi_range(0, len(PowerUps) - 1)
	
	# Alternate between player1 and player2
	var current_player = player1 if rng.randi_range(0, 1) == 0 else player2
	
	# Instantiate and assign the power-up to the current player
	if power_up_factory:
		var power_up_instance = power_up_factory.power_up_factory(rand_num)  # Make sure this method exists in PowerUpFactory
		if power_up_instance:
			current_player.add_to_inventory(power_up_instance)
			print("Power-up added to", current_player.name, "'s inventory")
	else:
		print("Warning: Power-up factory is not initialized.")
