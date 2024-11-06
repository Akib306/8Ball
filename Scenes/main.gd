extends Node2D

@export var ball : PackedScene

var ball_images := []
var cue_ball
const START_POS := Vector2(1200,350)
const MAX_POWER := 8.0
var taking_shot : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball = load("res://Scenes/ball.tscn") as PackedScene
	load_images()

	new_game()

func new_game():
	generate_balls()
	reset_cue_ball()
	show_cue()
	
func load_images():
	for i in range(1,  17, 1):
		var filename = str("res://Assets/ball_", i, ".png")
		var ball_image = load(filename)
		ball_images.append(ball_image)
func generate_balls():
	# Setup game balls
	var rows : int = 5
	var dia = 36
	var scale_percentage = 0.5  # Set desired scale as a percentage (e.g., 0.5 for 50%)
	var count = 0
	for col in range(5):
		for row in range(rows):
			var b = ball.instantiate()
			var pos = Vector2(250 + (col * dia), 267 + (row * dia) + (col * dia / 2))
			add_child(b)
			b.position = pos
			
			# Apply texture and scaling
			var sprite_node = b.get_node("Sprite2D")
			sprite_node.texture = ball_images[count]
			count += 1

			# Scale the sprite to the desired percentage
			#if sprite_node.texture:
				#var original_size = sprite_node.texture.get_size()
				#var target_size = original_size * scale_percentage
				#sprite_node.scale = target_size / original_size
		rows -= 1

func reset_cue_ball():
	cue_ball = ball.instantiate()
	add_child(cue_ball)
	cue_ball.position = START_POS
	cue_ball.get_node("Sprite2D").texture = ball_images.back()
	taking_shot = false
# Called every frame. 'delta' is the elapsed time since the previous frame.

func show_cue():
	$Cue.position = cue_ball.position
	$Cue.show()
	
	
func hide_cue():
	$Cue.hide()

func _process(delta) -> void:
	var moving := false
	for b in get_tree().get_nodes_in_group("balls"):
		if b.linear_velocity.length() >= 7:
			moving = true
			print("true")
			
	if not moving:
		if not taking_shot:
			taking_shot = true
			show_cue()
			print(false)
	else:
		if taking_shot:
			taking_shot = false
			
			hide_cue()
			print("idk")


func _on_cue_shoot(power):
	cue_ball.apply_impulse(power)
