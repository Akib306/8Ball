extends Node2D

@export var ball : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball = load("res://path/to/your/scene.tscn") as PackedScene
	new_game()

func new_game():
	generate_balls()
	
func generate_balls():
	#setup game balls
	var rows : int = 5
	var dia = 36
	for col in range(5):
		for row in range(rows):
			var b = ball.instantiate()
			var pos = Vector2(250 + (col * (dia)), 267 + (row * (dia)) + (col * dia / 2))
			add_child(b)
			b.position = pos
			b.get_node("Sprite2D").texture = load("res://Assets/ball 1.png")
		rows -= 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass
