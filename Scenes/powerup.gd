extends Node2D

var rng = RandomNumberGenerator.new()
enum PowerUps { TELEPORT, WALL, MRBIG, TORNADO, REWIND, GHOST }

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect("power_gamble", Callable(self, "power_draw"))

func power_draw() -> void:
	var rand_num = rng.randi_range(0, 10)
	print(rand_num)
	if rand_num < 4: 
		power_selector()
	

func power_selector():
	print("Random power is being drawn...")
	var rand_num = rng.randi_range(0, 5)
	power_up_factory(rand_num)  

func power_up_factory(power_up: int):
	
	match power_up:
		PowerUps.TELEPORT:
			print("Teleport power-up created")
		PowerUps.WALL:
			print("Wall power-up created")
		PowerUps.MRBIG:
			print("MrBig power-up created")
		PowerUps.TORNADO:
			print("Tornado power-up created")
		PowerUps.REWIND:
			print("Rewind power-up created")
		PowerUps.GHOST:
			print("Ghost power-up created")
