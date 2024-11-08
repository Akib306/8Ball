extends Node2D

# Reference to the PowerUpFactory and Player (assume Player.gd for each player)
@export var player1: int  
@export var player2: int
@export var power_up_factory_scene: PackedScene  
var rng = RandomNumberGenerator.new()

# Enum to define power-ups
enum PowerUps { TELEPORT, WALL, MRBIG, TORNADO, REWIND, GHOST }

# Instance variable for the power-up factory
var power_up_factory: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the power-up event
	get_parent().connect("power_gamble", Callable(self, "power_draw"))
	
	# Instantiate the power-up factory
	if power_up_factory_scene:
		power_up_factory = power_up_factory_scene.instantiate()
		add_child(power_up_factory)

# Draw a power-up randomly
func power_draw() -> void:
	var rand_num = rng.randi_range(0, 10)
	print(rand_num)
	if rand_num < 4: 
		power_selector()

# Select and assign a random power-up to the current player
func power_selector():
	print("Random power is being drawn...")
	var rand_num = rng.randi_range(0, len(PowerUps) - 1)
	
	# Get the current player (for example purposes, this could be alternated)
	var current_player = player1 if rng.randi_range(0, 1) == 0 else player2
	
	# Instantiate and assign the power-up
	if power_up_factory:
		var power_up_instance = power_up_factory.power_up_factory(rand_num)
		if power_up_instance:
			current_player.add_to_inventory(power_up_instance)
			print("Power-up added to", current_player.name, "'s inventory")
