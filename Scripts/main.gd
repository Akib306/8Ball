extends Node2D

@export var ball : PackedScene
@export var power_up_ui: Control
signal power_gamble

@onready var turn_timer: Timer = $TurnTimer
@onready var timer_label: Label = $TimerLabel

const TURN_TIME := 10.0  

var ball_images := []
const BALL_SCALE := 0.35
const MAX_POWER := 8.0
var taking_shot : bool
const MOVE_THRESHOLD := 7.0
var cue_ball_potted : bool
var potted := []
var camera: Camera2D  # Global variable for the camera
var game_controller: Node2D

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
var player_potted_correct_ball := false  # New flag to track correct potting

#####################################################################################################

func _ready() -> void:
	ball = load("res://Scenes/ball.tscn") as PackedScene
	camera = $Pool_Table/Camera2D  # Adjust the path if necessary

	game_controller = $gameController
	power_up_ui = $PowerupUI

	load_images()
	new_game()

	$Pool_Table/Pockets.body_entered.connect(potted_ball)

#####################################################################################################

func _process(delta: float) -> void:
	var moving := false
	for b in get_tree().get_nodes_in_group("balls"):
		# Rotate sprite based on angular velocity
		var sprite = b.get_node("Sprite2D")
		if sprite and b.angular_velocity != 0:
			sprite.rotation += b.angular_velocity * delta
			
		# Check ball movement
		if (b.linear_velocity.length() > 0.0 and 
			b.linear_velocity.length() < MOVE_THRESHOLD):
			b.sleeping = true
		elif b.linear_velocity.length() >= MOVE_THRESHOLD:
			moving = true

	if not moving:
		if cue_ball_potted:
			reset_cue_ball()
			cue_ball_potted = false

		if not taking_shot:
			# Ensure no turn switch at the start if no player type has been assigned
			if current_player.type == "" and player2.type == "":
				taking_shot = true
				show_cue()
				return  # Exit early to prevent switching turns

			# Only switch turns if no correct ball was potted
			if not player_potted_correct_ball:
				switch_turn()
			else:
				player_potted_correct_ball = false  # Reset flag if turn retained
			taking_shot = true
			show_cue()

	else:
		if taking_shot:
			taking_shot = false
			hide_cue()

#####################################################################################################

# **Added this method for cue ball strike sound**
func play_cue_strike_sound():
	$CueStrikeAudio.play()

#####################################################################################################

# **Added this method for ball potting sound**
func play_ball_pot_sound():
	$BallPotAudio.play()

#####################################################################################################

func new_game():
	generate_balls()
	reset_cue_ball()
	show_cue()
	#update_power_up_ui()

#####################################################################################################

func load_images():
	for i in range(1, 17, 1):
		var filename = str("res://Assets/ball_", i, ".png")
		var ball_image = load(filename)
		ball_images.append(ball_image)

#####################################################################################################

func generate_balls():
	var num_of_col_row : int = 5
	var dia = 36
	var count = 0

	var start_x = camera.position.x - (camera.get_viewport_rect().size.x * 0.3) 
	var start_y = camera.position.y - (camera.get_viewport_rect().size.y * .1) 

	for col in range(num_of_col_row):
		for row in range(num_of_col_row):
			var b = ball.instantiate()
			var pos = Vector2(start_x + (col * dia), 
				start_y + (row * dia) + (col * dia / 2))
			add_child(b)
			b.position = pos
			b.add_to_group("balls")

			# Assign sprite texture
			var sprite_node = b.get_node("Sprite2D")
			sprite_node.texture = ball_images[count]
			sprite_node.scale  = Vector2(BALL_SCALE, BALL_SCALE)
			
			b.call("set_physics_properties", 0.1, 0.8, 0.98)
			
			# Handle collision shapes
			var collision_sprite_node = b.get_node("CollisionShape2D")
			collision_sprite_node.scale  = Vector2(BALL_SCALE, BALL_SCALE)
			
			# Group balls by type
			if count < 7:
				solids.append(b)  # Balls 1-7 are solids
			elif count == 7:
				black_ball = b  # Ball 8 is the black ball
			elif count >= 8 and count < 15:
				stripes.append(b)  # Balls 9-15 are stripes
			elif count == 15:
				cue_ball = b  # Ball 16 is the cue ball\
				
			count += 1

		num_of_col_row -= 1

#####################################################################################################

func reset_cue_ball():
	# Instantiate the cue ball
	cue_ball = ball.instantiate()
	add_child(cue_ball)
	cue_ball.position = Vector2(camera.position.x + 200, camera.position.y - 60)

	# Configure the cue ball (texture, scale, etc.)
	var sprite_node = cue_ball.get_node("Sprite2D")
	sprite_node.texture = ball_images.back()
	sprite_node.scale = Vector2(BALL_SCALE, BALL_SCALE)

	var collision_node = cue_ball.get_node("CollisionShape2D")
	collision_node.scale = Vector2(BALL_SCALE, BALL_SCALE)

	taking_shot = false

	# Assign the cue_ball to Line2D
	if $Cue and $Cue.has_node("Line2D"):
		$Cue/Line2D.cue_ball = cue_ball
		print("Cue ball assigned to Line2D:", cue_ball)
	else:
		print("Line2D not found in Cue!")


func remove_cue_ball():
	var old_b = cue_ball
	remove_child(old_b)
	old_b.queue_free()

#####################################################################################################

func show_cue():
	$Cue.set_process(true)
	$Cue.position = cue_ball.position
	$PowerBar.position.x = cue_ball.position.x - (0.5 * $PowerBar.size.x)
	$PowerBar.position.y = cue_ball.position.y + (0.5 * $PowerBar.size.y)
	$Cue.show()
	$PowerBar.show()

#####################################################################################################

func hide_cue():
	$Cue.set_process(false)
	$Cue.hide()
	$PowerBar.hide()

#####################################################################################################

func _on_cue_shoot(power: Vector2):
	# Apply central impulse for forward motion
	cue_ball.apply_central_impulse(power)
	play_cue_strike_sound() 
	# Add spin (angular velocity) based on the cue's force and direction
	# For example, simulate slight top or side spin
	var spin_strength = 0.2  # Adjust as needed for realism
	cue_ball.angular_velocity = power.x * spin_strength

func potted_ball(body):
	if body == cue_ball:
		handle_cue_ball_pot()
	else:
		play_ball_pot_sound()
		handle_ball_pot(body)

func handle_cue_ball_pot():
	cue_ball_potted = true
	remove_cue_ball()
	play_ball_pot_sound()
	switch_turn()

func handle_ball_pot(body):
	if current_player.type == "":
		assign_player_ball_type(body)

	if is_correct_ball(body):
		current_player.score += 1
		print(current_player.name, " potted a ", current_player.type, 
			"! Score: ", current_player.score)
		player_potted_correct_ball = true  # Retain turn if correct ball potted
		game_controller.power_draw(current_player)
		
	else:
		play_ball_pot_sound()
		print(current_player.name, " fouled by hitting the wrong ball type.")
		player_potted_correct_ball = false  # Switch turn on foul
		#switch_turn()
	
	handle_ball_removal(body)
	display_potted_ball(body)

func check_win_condition(body):
	if body == black_ball:
		if solids.is_empty() and current_player.type == "solids":
			# emit_signal("win", current_player.name)
			print(current_player.name + " won")
		elif stripes.is_empty() and current_player.type == "stripes":
			# emit_signal("win", current_player.name)
			print(current_player.name + " won")

func handle_ball_removal(body):
	if solids.has(body):
		solids.erase(body)
	elif stripes.has(body):
		stripes.erase(body)
	
	check_win_condition(body)

func assign_player_ball_type(body):
	if solids.has(body):
		current_player.assign_type("solids")
		(player1 if current_player == player2 else player2).assign_type("stripes")
		print(current_player.name, " is now assigned solids.")
	elif stripes.has(body):
		current_player.assign_type("stripes")
		(player1 if current_player == player2 else player2).assign_type("solids")
		print(current_player.name, " is now assigned stripes.")

func is_correct_ball(body) -> bool:
	return (current_player.type == "solids" and solids.has(body)) or (
		current_player.type == "stripes" and stripes.has(body))

func display_potted_ball(body):
	var max_balls_per_row := 5
	var ball_size := 25
	var scale_factor := 0.5
	var scaled_ball_size := ball_size * scale_factor

	var b = Sprite2D.new()
	add_child(b)
	b.texture = body.get_node("Sprite2D").texture
	potted.append(b)
	b.scale = Vector2(scale_factor, scale_factor)

	var panel_position = $PottedPanel.position
	var panel_width = $PottedPanel.size.x
	var panel_height = $PottedPanel.size.y
	var total_row_width = ((max_balls_per_row * scaled_ball_size) + 
		((max_balls_per_row - 1) * scaled_ball_size / 2))
	var x_offset = (panel_width - total_row_width) / 2

	var index = potted.size() - 1
	var row = index / max_balls_per_row
	var col = index % max_balls_per_row

	var x_pos = (panel_position.x + x_offset + 
		(col * (scaled_ball_size + scaled_ball_size / 2)))
	var y_pos = (panel_position.y + (panel_height / 2) - 
		(scaled_ball_size / 2) + (row * scaled_ball_size))
	b.position = Vector2(x_pos - 525, y_pos)

	body.queue_free()

func switch_turn():
	current_player = player2 if current_player == player1 else player1
	#update_power_up_ui()
	print("It's now ", current_player.name, "'s turn.")

#####################################################################################################
