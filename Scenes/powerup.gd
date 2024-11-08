extends Node2D

var rng = RandomNumberGenerator.new() 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"..".connect("power_gamble", Callable(self, "power_draw"))

func power_draw() -> void:
	var rand_num = rng.randi_range(0, 10)
	if rand_num < 4: 
		power_selector()
	print(rand_num)


func power_selector():
	print("Random power is being drawn...")
	# Place where all the different power ups will go 
