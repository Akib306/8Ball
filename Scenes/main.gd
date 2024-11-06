extends Node2D

@export var ball : PackedScene

var ball_images := []
var cue_ball
const START_POS := Vector2(1200,350)
const MAX_POWER := 8.0
var taking_shot : bool
const MOVE_THRESHOLD := 7.0
var cue_ball_potted : bool
var potted := []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball = load("res://Scenes/ball.tscn") as PackedScene
	load_images()
	new_game()
	$Pool_Tabel/Pockets.body_entered.connect(potted_ball)

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

func remove_cue_ball():
	var old_b = cue_ball
	remove_child(old_b)
	old_b.queue_free()

func show_cue():
	$Cue.set_process(true)
	$Cue.position = cue_ball.position
	$PowerBar.position.x = cue_ball.position.x - (0.5 * $PowerBar.size.x)
	$PowerBar.position.y = cue_ball.position.y + (0.5 * $PowerBar.size.y)
	$Cue.show()
	$PowerBar.show()
	
func hide_cue():
	$Cue.set_process(false)
	$Cue.hide()
	$PowerBar.hide()

func _process(_delta) -> void:
	var moving := false
	for b in get_tree().get_nodes_in_group("balls"):
		if (b.linear_velocity.length() > 0.0 and b.linear_velocity.length() < MOVE_THRESHOLD):
			b.sleeping = true
		elif b.linear_velocity.length() >= MOVE_THRESHOLD:
			moving = true
			
			
	if not moving:
		if cue_ball_potted:
			reset_cue_ball()
			cue_ball_potted = false
			
		if not taking_shot:
			taking_shot = true
			show_cue()
			
	else:
		if taking_shot:
			taking_shot = false
			
			hide_cue()
			


func _on_cue_shoot(power):
	cue_ball.apply_impulse(power)

func potted_ball(body):
	if body == cue_ball:
		cue_ball_potted = true
		remove_cue_ball()
	else:
		
		#image needs to be resized
		var b = Sprite2D.new()
		add_child(b)
		b.texture = body.get_node("Sprite2D").texture
		potted.append(b)
		b.position = Vector2(25 * potted.size(), 825)
		body.queue_free()
	
