extends Node2D

@export var ball : PackedScene

var ball_images := []
const MAX_POWER := 8.0
var taking_shot : bool
const MOVE_THRESHOLD := 7.0
var cue_ball_potted : bool
var potted := []
var camera: Camera2D  # Global variable for the camera

# Arrays for solids, stripes, and special balls
var solids := []
var stripes := []
var black_ball
var cue_ball

# Set up players
var player1 = Player.new("Player 1", true)  # Player 1 starts with the first turn
var player2 = Player.new("Player 2", false) # Player 2 starts without a turn
var current_player = player1

# Variables for turn logic
var first_ball_pocketed: bool = false
var first_ball_hit_in_shot: bool = false
var first_ball_hit: Node = null
var player_potted_own_ball_this_shot: bool = false
var foul_committed_this_shot: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball = load("res://Scenes/ball.tscn") as PackedScene
	camera = $Pool_Table/Camera2D  # Adjust the path if necessary

	load_images()
	new_game()
	$Pool_Table/Pockets.body_entered.connect(potted_ball)
	
	# Set the global camera reference

func new_game():
	generate_balls()
	reset_cue_ball()
	show_cue()

func load_images():
	for i in range(1, 17, 1):
		var filename = str("res://Assets/ball_", i, ".png")
		var ball_image = load(filename)
		ball_images.append(ball_image)

func generate_balls():
	# Setup game balls
	var rows : int = 5
	var dia = 36
	var count = 0

	# Use the camera's position for calculating the start position
	var camera_center_x = camera.position.x
	var camera_center_y = camera.position.y

	# Set start position based on 30% from the left edge of the camera view for x
	var start_x = camera_center_x - (camera.get_viewport_rect().size.x * 0.3) 
	# Center vertically based on the camera's position
	var start_y = camera_center_y - (camera.get_viewport_rect().size.y * .1) 

	for col in range(5):
		for row in range(rows):
			var b = ball.instantiate()
			
			# Calculate position based on camera view and stagger for triangle shape
			var pos = Vector2(
				# Horizontal position with 30% offset from camera center
				start_x + (col * dia),  
				
				# Staggered vertical position for triangle shape
				start_y + (row * dia) + (col * dia / 2)  
			)
			add_child(b)
			b.position = pos

			# Apply texture
			var sprite_node = b.get_node("Sprite2D")
			sprite_node.texture = ball_images[count]
			
			# Sort balls into solids, stripes, or special balls
			if count < 7:
				solids.append(b)  # Balls 1-7 are solids
			elif count == 7:
				black_ball = b  # Ball 8 is the black ball
			elif count >= 8 and count < 15:
				stripes.append(b)  # Balls 9-15 are stripes
			elif count == 15:
				cue_ball = b  # Ball 16 is the cue ball, using existing cue_ball variable

			count += 1

		rows -= 1  # Reduce the number of balls per row for the triangular layout
	
	# Print each array after ball generation
	print("Solids:", solids)
	print("Stripes:", stripes)
	print("Black Ball:", black_ball)

func reset_cue_ball():
	cue_ball = ball.instantiate()
	add_child(cue_ball)
	
	# Calculate the START_POS dynamically based on the camera's position
	var START_POS = Vector2(camera.position.x + 200, camera.position.y -60) 
	cue_ball.position = START_POS
	cue_ball.get_node("Sprite2D").texture = ball_images.back()
	taking_shot = false

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
		if (b.linear_velocity.length() > 0.0 and b.linear_velocity.length() 
		< MOVE_THRESHOLD):
			b.sleeping = true
		elif b.linear_velocity.length() >= MOVE_THRESHOLD:
			moving = true

	if not moving:
		if cue_ball_potted:
			reset_cue_ball()
			cue_ball_potted = false
			
		if not taking_shot:
			if current_player.type != "":  # Only switch if types are assigned
				switch_turn()
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
		switch_turn()
	else:
		if current_player.type == "":
			if solids.has(body):
				current_player.assign_type("solids")
				(player1 if current_player == player2 else player2).assign_type("stripes")
				print(current_player.name, "is now assigned solids.")
			elif stripes.has(body):
				current_player.assign_type("stripes")
				(player1 if current_player == player2 else player2).assign_type("solids")
				print(current_player.name, "is now assigned stripes.")
		
		var is_correct_ball = (current_player.type == "solids" and solids.has(body)) or (current_player.type == "stripes" and stripes.has(body))
		
		if is_correct_ball:
			current_player.score += 1
			print(current_player.name, "potted a", current_player.type, "! Score:", current_player.score)
		else:
			print(current_player.name, "fouled by hitting the wrong ball type.")
			switch_turn()
		
		# Retrieve the necessary nodes and settings directly from PottedPanel
		var max_balls_per_row := 5  # Maximum balls per row
		var ball_size := 25  # Width/height of each potted ball image before scaling
		var scale_factor := 0.5  # Scale down factor for the balls
		var scaled_ball_size := ball_size * scale_factor  # Effective size of each scaled ball

		# Create a new Sprite2D for the potted ball
		var b = Sprite2D.new()
		add_child(b)
		b.texture = body.get_node("Sprite2D").texture
		potted.append(b)
		b.scale = Vector2(scale_factor, scale_factor)  # Apply the scale factor

		# Get PottedPanel position and size for dynamic placement
		var panel_position = $PottedPanel.position
		var panel_width = $PottedPanel.size.x
		var panel_height = $PottedPanel.size.y

		# Calculate the horizontal offset to center balls within the panel
		var total_row_width = ((max_balls_per_row * scaled_ball_size) + 
		((max_balls_per_row - 1) * scaled_ball_size / 2))
		
		var x_offset = (panel_width - total_row_width) / 2

		# Calculate position within PottedPanel based on current index
		var index = potted.size() - 1
		var row = index / max_balls_per_row
		var col = index % max_balls_per_row
		
		# Calculate the x position with offset and spacing
		var x_pos = (panel_position.x + x_offset + 
		(col * (scaled_ball_size + scaled_ball_size / 2)))

		# Calculate the y position to keep balls vertically centered in the panel
		var y_pos = (panel_position.y + (panel_height / 2) - 
		(scaled_ball_size / 2) + (row * scaled_ball_size))

		# Set ball position
		b.position = Vector2(x_pos -525, y_pos)

		# Remove the potted ball from the main table
		body.queue_free()

func switch_turn():
	current_player = player2 if current_player == player1 else player1
	print("It's now", current_player.name, "'s turn.")
