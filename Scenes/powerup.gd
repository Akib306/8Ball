extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"..".connect("power_gamble", Callable(self, "power_draw"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func power_draw() -> void: 
	print("Ball has gone in")
