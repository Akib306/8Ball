extends Node2D

@export var ball : PackedScene
signal power_gamble
@onready var turn_timer: TurnTimer = $TurnTimer
@onready var timer_label: Label = $TurnTimer/TimerLabel
@onready var power_up_ui: PowerUpUI = $PowerupUI
var is_mouse_over_ui: bool = false
@onready var player1_icon: Button = $header_gui/CenterContainer/player_profile/player_1_profile/Button
@onready var player2_icon: Button = $header_gui/CenterContainer/player_profile/player_2_profile/Button
@onready var player1_label: Label = $header_gui/CenterContainer/player_profile/player_1_profile/Panel/CenterContainer/Player1
@onready var player2_label: Label = $header_gui/CenterContainer/player_profile/player_2_profile/Panel/CenterContainer/Player1
var cue
const TURN_TIME := 10.0  

var ball_images := []
const BALL_SCALE := 0.35
const MAX_POWER := 8.0
var taking_shot : bool
const MOVE_THRESHOLD := 7.0
var cue_ball_potted : bool
var potted := []
var camera: Camera2D  # Global variable for the camera
var powerupManager: PowerUpManager

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

func _ready() -> void:
	ball = load("res://Scenes/ball.tscn") as PackedScene
	camera = $Pool_Table/Camera2D  # Adjust the path if necessary
	turn_timer.connect("timeout", Callable(self, "_on_timeout"))
	$PowerupUI/VBoxContainer/HBoxContainer/Slot1.connect("mouse_entered", Callable(self, "_on_ui_mouse_entered"))
	$PowerupUI/VBoxContainer/HBoxContainer/Slot1.connect("mouse_exited", Callable(self, "_on_ui_mouse_exited"))
	$PowerupUI/VBoxContainer/HBoxContainer/Slot2.connect("mouse_entered", Callable(self, "_on_ui_mouse_entered"))
	$PowerupUI/VBoxContainer/HBoxContainer/Slot2.connect("mouse_exited", Callable(self, "_on_ui_mouse_exited"))
	$PowerupUI/VBoxContainer/HBoxContainer/Slot3.connect("mouse_entered", Callable(self, "_on_ui_mouse_entered"))
	$PowerupUI/VBoxContainer/HBoxContainer/Slot3.connect("mouse_exited", Callable(self, "_on_ui_mouse_exited"))
	powerupManager = PowerUpManager.new()
	powerupManager.set_main_game(self)
	powerupManager.power_up_factory = PowerUpFactory.new()	
	power_up_ui.player = current_player
	power_up_ui.powerup_manager = powerupManager
	power_up_ui.update_ui()
	
	cue = $Cue
	load_images()
	new_game()
	
	$Pool_Table/Pockets.body_entered.connect(potted_ball)
	
#####################################################################################################
func _on_ui_mouse_entered() -> void:
	is_mouse_over_ui = true
	
func _on_ui_mouse_exited() -> void:
	is_mouse_over_ui = false

	
func _unhandled_input(event):
	if taking_shot:
		return  # Ignore input while a shot is being taken
	
	if is_mouse_over_ui:
		return
			
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			current_player.activate_power_up(0, powerupManager)
			
			
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

func play_cue_strike_sound():
	$CueStrikeAudio.play()

func play_ball_pot_sound():
	$BallPotAudio.play()

func new_game():
	generate_balls()
	reset_cue_ball()
	show_cue()
	#update_power_up_ui()

func load_images():
	for i in range(1, 17, 1):
		var filename = str("res://Assets/ball_", i, ".png")
		var ball_image = load(filename)
		ball_images.append(ball_image)

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

func show_cue():
	$Cue.set_process(true)
	$Cue.position = cue_ball.position
	$PowerBar.position.x = cue_ball.position.x - (0.5 * $PowerBar.size.x)
	$PowerBar.position.y = cue_ball.position.y + (0.5 * $PowerBar.size.y)
	$Cue.show()
	$PowerBar.show()
	turn_timer.start_timer()

func hide_cue():
	$Cue.set_process(false)
	$Cue.hide()
	$PowerBar.hide()

func _on_cue_shoot(power: Vector2):
	
	turn_timer.stop_timer()
	
	# Apply central impulse for forward motion
	cue_ball.apply_central_impulse(power)
	
	play_cue_strike_sound() 
	
	# Reset the first ball hit tracking
	first_ball_hit = null
	foul_committed_this_shot = false
	
	# Add spin (angular velocity) based on the cue's force and direction
	var spin_strength = 0.2
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
	
	display_potted_ball(body)
	
	# Black ball handling
	if handle_black_ball(body):
		return
	
	# At the beginning of the game
	power_up_ui.update_ui()
	if current_player.type == "":
		assign_player_ball_type(body)

	if is_correct_ball(body):
		calculate_score(body, current_player)
		player_potted_correct_ball = true  # Retain turn if correct ball potted
		powerupManager.power_draw(current_player)
		power_up_ui.update_ui()
		
	else:
		play_ball_pot_sound()
		
		if current_player == player1:
			calculate_score(body, player2)
			
		elif current_player == player2:
			calculate_score(body, player1)

		print(current_player.name, " fouled by potting the wrong ball type.")
		player_potted_correct_ball = false  # Switch turn on foul

	print(player1.name, "'s score is ", player1.score)
	print(player2.name, "'s score is ", player2.score)

func calculate_score(body, player: Player):
	
	handle_ball_removal(body)
	
	if player.type == "solids":
		player.score = 7 - solids.size()
		
		if player.score == 7:
			player.can_win = true
	
	elif player.type == "stripes":
		player.score = 7 - stripes.size()
		
		if player.score == 7:
			player.can_win = true

func handle_black_ball(body):
	# Check if the black ball is potted
	if body != black_ball:
		return false  # Not the black ball, no special handling needed
	
	# Check if the player can win
	if current_player.can_win:
		print(current_player.name, " potted the black ball and won the game!")
		declare_winner(current_player)
	else:
		print(current_player.name, " fouled by potting the black ball too early!")
		declare_winner(player1 if current_player == player2 else player2)
	
	return true

func declare_winner(winning_player: Player):
	turn_timer.stop_timer()
	print("Congratulations ", winning_player.name, " you win!")
	# Add any GUI updates or game-ending logic here
	# Example:
	# game_over_ui.show_winner(winning_player.name)

func handle_ball_removal(body):
	if solids.has(body):
		solids.erase(body)
	elif stripes.has(body):
		stripes.erase(body)

func assign_player_ball_type(body):
	
	if solids.has(body):
		if current_player == player1: 
			player1_label.text = "Player 1 (Solids)"
			player2_label.text = "Player 2 (Stripes)"
		else:
			player2_label.text = "Player 2 (Solids)"
			player1_label.text = "Player 1 (Stripes)"
		current_player.assign_type("solids")
		(player1 if current_player == player2 else player2).assign_type("stripes")
		print(current_player.name, " is now assigned solids.")
	
	elif stripes.has(body):
		if current_player == player1: 
			player1_label.text = "Player 1 (Stripes)"
			player2_label.text = "Player 2 (Solid)"
		else:
			player2_label.text = "Player 2 (Stripes)"
			player1_label.text = "Player 1 (Solids)"
		current_player.assign_type("stripes")
		(player1 if current_player == player2 else player2).assign_type("solids")
		print(current_player.name, " is now assigned stripes.")

func is_correct_ball(body) -> bool:
	return (current_player.type == "solids" and solids.has(body)) or (
		current_player.type == "stripes" and stripes.has(body))

func display_potted_ball(body):
	var max_balls_per_row := 15
	var scale_factor := 0.4

	var b = Sprite2D.new()
	add_child(b)
	b.texture = body.get_node("Sprite2D").texture
	potted.append(b)
	b.scale = Vector2(scale_factor, scale_factor)
	
	# set up ball position
	var panel_position = $Pot/PottedPanel.position
	var x_pos = panel_position.x - 10 + 60 * potted.size()
	var panel_height = $Pot/PottedPanel.size.y
	var y_pos = (panel_position.y + (panel_height / 2))
	
	b.position = Vector2(x_pos, y_pos)

	body.queue_free()

func _on_timeout():
	# Handle timeout: switch turns and restart the timer
	print("Time's up for", current_player.name)
	switch_turn()

func switch_turn():
	turn_timer.stop_timer()

	# Handle the end of the current player's turn
	powerupManager.on_turn_end(current_player)

	# Switch to the next player
	current_player = player2 if current_player == player1 else player1
	#update_power_up_ui()
	power_up_ui.player = current_player
	power_up_ui.update_ui()

	# Start the timer for the new player
	print("It's now ", current_player.name, "'s turn.")
	turn_timer.start_timer()
