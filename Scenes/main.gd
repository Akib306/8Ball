extends Node2D

@export var ball : PackedScene

var ball_images := []
var cue_ball
const MAX_POWER := 8.0
var taking_shot : bool
const MOVE_THRESHOLD := 7.0
var cue_ball_potted : bool
var potted := []
var camera: Camera2D  # Global variable for the camera

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

	# Set start position based on 30% from the left edge of the camera view for x and center y
	var start_x = camera_center_x - (camera.get_viewport_rect().size.x * 0.3)  # 30% offset from left edge
	var start_y = camera_center_y - (camera.get_viewport_rect().size.y * .1) # Center vertically based on the camera's position

	for col in range(5):
		for row in range(rows):
			var b = ball.instantiate()
			
			# Calculate position based on camera view and stagger for triangle shape
			var pos = Vector2(
				start_x + (col * dia),  # Horizontal position with 30% offset from camera center
				start_y + (row * dia) + (col * dia / 2)  # Staggered vertical position for triangle shape
			)
			add_child(b)
			b.position = pos

			# Apply texture
			var sprite_node = b.get_node("Sprite2D")
			sprite_node.texture = ball_images[count]
			count += 1

		rows -= 1  # Reduce the number of balls per row for the triangular layout

func reset_cue_ball():
	cue_ball = ball.instantiate()
	add_child(cue_ball)
	
	# Calculate the START_POS dynamically based on the camera's position
	var START_POS = Vector2(camera.position.x + 200, camera.position.y)  # Adjust offsets as needed
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
	
