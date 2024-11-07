extends Node2D

@export var ball : PackedScene

var ball_images := []
var cue_ball
const START_POS := Vector2(1200,720)
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
	#$Pool_Table/Pockets.body_entered.connect(potted_ball)

func new_game():
	generate_balls()
	#reset_cue_ball()
	#show_cue()
	
func load_images():
	for i in range(1,  17, 1):
		var filename = str("res://Assets/ball_", i, ".png")
		var ball_image = load(filename)
		ball_images.append(ball_image)
		
#func generate_balls():
	## Setup game balls
	#var rows : int = 5
	#var dia = 72
	#var count = 0
	#for col in range(5):
		#for row in range(rows):
			#var b = ball.instantiate()
			#var pos = Vector2(250 + (col * (dia)), 250 + (row * (dia)) + (col * (dia/2)))
			#add_child(b)
			#b.position = pos
			#
			## Apply texture and scaling
			#var sprite_node = b.get_node("Sprite2D")
			#sprite_node.texture = ball_images[count]
			#count += 1
			#
		#rows -= 1
		

#func generate_balls():
	#var rows: int = 5
	#var dia: int = 36
	#var count: int = 0
#
	## Start position (leftmost point of triangle)
	#var start_x = 600
	#var start_y = 700
#
	## Spacing constants
	#var x_offset = dia * 0.5 # Adjust horizontal offset for the triangle pattern
	#var y_offset = dia * 0.866 # sin(60°) * diameter for correct vertical offset
#
	#for row in range(rows):
		## Center each row around the starting x position
		#var row_start_x = start_x - (row * x_offset / 2)
#
		#for col in range(row + 1):
			#var b = ball.instantiate()
#
			## Calculate position for each ball
			#var x = row_start_x + (col * x_offset)
			#var y = start_y - (row * y_offset)
#
			#b.position = Vector2(x, y)
			#add_child(b)
#
			## Assign texture to the ball's sprite
			#var sprite_node = b.get_node("Sprite2D")
			#sprite_node.texture = ball_images[count]
			#count += 1

func generate_balls():
	# Reference the pool table node (Sprite2D)
	var table = $Pool_Table  # Adjust the path as needed to access the table node
	
	# Setup game balls
	var rows : int = 5
	var dia = 40
	var count = 0

	# Get pool table dimensions from the texture
	var table_width = table.texture.get_width() * 5
	var table_height = table.texture.get_height() 
	var start_x = ((table_width / 2) - (2 * dia)) # Center the triangle horizontally
	var start_y = (table_height / 3) + 600 # Position the triangle vertically, 1/3 down the table

	for col in range(5):
		for row in range(rows):
			var b = ball.instantiate()

			# Calculate position based on the table dimensions and column/row offsets
			var pos = Vector2(
			start_x + (col * dia),  # Horizontal position
			start_y + (row * dia) + (col * dia / 2)  # Staggered vertical position for triangle formation
			)
			add_child(b)
			b.position = pos

			# Apply texture
			var sprite_node = b.get_node("Sprite2D")
			sprite_node.texture = ball_images[count]
			count += 1

		rows -= 1  # Reduce the number of balls per row for the triangular layout


#func reset_cue_ball():
	#cue_ball = ball.instantiate()
	#add_child(cue_ball)
	#cue_ball.position = START_POS
	#cue_ball.get_node("Sprite2D").texture = ball_images.back()
	#taking_shot = false
## Called every frame. 'delta' is the elapsed time since the previous frame.
#
#func remove_cue_ball():
	#var old_b = cue_ball
	#remove_child(old_b)
	#old_b.queue_free()
#
#func show_cue():
	#$Cue.set_process(true)
	#$Cue.position = cue_ball.position
	#$PowerBar.position.x = cue_ball.position.x - (0.5 * $PowerBar.size.x)
	#$PowerBar.position.y = cue_ball.position.y + (0.5 * $PowerBar.size.y)
	#$Cue.show()
	#$PowerBar.show()
	#
#func hide_cue():
	#$Cue.set_process(false)
	#$Cue.hide()
	#$PowerBar.hide()
#
#func _process(_delta) -> void:
	#var moving := false
	#for b in get_tree().get_nodes_in_group("balls"):
		#if (b.linear_velocity.length() > 0.0 and b.linear_velocity.length() < MOVE_THRESHOLD):
			#b.sleeping = true
		#elif b.linear_velocity.length() >= MOVE_THRESHOLD:
			#moving = true
			#
			#
	#if not moving:
		#if cue_ball_potted:
			#reset_cue_ball()
			#cue_ball_potted = false
			#
		#if not taking_shot:
			#taking_shot = true
			#show_cue()
			#
	#else:
		#if taking_shot:
			#taking_shot = false
			#
			#hide_cue()
			#
#
#
#func _on_cue_shoot(power):
	#cue_ball.apply_impulse(power)
#
#func potted_ball(body):
	#if body == cue_ball:
		#cue_ball_potted = true
		#remove_cue_ball()
	#else:
		#
		##image needs to be resized
		#var b = Sprite2D.new()
		#add_child(b)
		#b.texture = body.get_node("Sprite2D").texture
		#potted.append(b)
		#b.position = Vector2(25 * potted.size(), 825)
		#body.queue_free()
	
