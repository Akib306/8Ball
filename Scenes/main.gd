extends Node2D

@export var ball : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball = load("res://Scenes/ball.tscn") as PackedScene
	new_game()

func new_game():
	generate_balls()
	
func generate_balls():
	# Setup game balls
	var rows : int = 5
	var dia = 36
	var scale_percentage = 0.5  # Set desired scale as a percentage (e.g., 0.5 for 50%)

	for col in range(5):
		for row in range(rows):
			var b = ball.instantiate()
			var pos = Vector2(250 + (col * dia), 267 + (row * dia) + (col * dia / 2))
			add_child(b)
			b.position = pos
			
			# Apply texture and scaling
			var sprite_node = b.get_node("Sprite2D")
			sprite_node.texture = load("res://Assets/ball 1.png")
			
			# Scale the sprite to the desired percentage
			#if sprite_node.texture:
				#var original_size = sprite_node.texture.get_size()
				#var target_size = original_size * scale_percentage
				#sprite_node.scale = target_size / original_size

		rows -= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass
